module shiftFuntions
    using JuMP, DataFrames, Taro, Gurobi

     # numtocol
    # Integer (>= 1) -> String
    # converts index to Excel col string, e.g. 1 -> A, 27 -> AA
    function numtocol(num)
        col = ""
        modulo = 1
        while num > 0
            modulo = (num - 1) % 26
            col =   string(
                        string(Char(modulo + 65)),
                        col)
            num = floor((num - modulo) / 26)
        end
        return col
    end

    function makeshifts()
        
        Taro.init()

        # number of staff (B27 on sheet)
        staff = Integer(getCellValue(getCell(getRow(getSheet(
                    Workbook("availability.xlsx"), "availability"), 27), 2)))

        # get staff availability tables
        # top left cell on row 2, bot right cell on row 23
        # each table separated by 7 cells

        staff_array = []                        # with preference/availability data
        staff_dict  = Dict{Integer, String}()   # with names of staff

        for i in 0:staff - 1
            range = string(numtocol(7 * i + 2),
                            "2:",
                            numtocol(7 * i + 6),
                            "23")
            push!(staff_array,
                DataFrame(Taro.readxl("availability.xlsx", "availability",
                range, header = false)))
            staff_dict[i + 1] = String(getCellValue(getCell(getRow(getSheet(
                Workbook("availability.xlsx"), "availability"), 0), 7 * i)))
        end

        # create 3D availability array
        av_matrix = Array{Int8}(undef, 22, 5, staff)

        for k in 1:staff
            for i in 1:22
                for j in 1:5
                    av_matrix[i,j,k] = Matrix(staff_array[k])[i,j]
                end
            end
        end

        # optimization model
        m = Model(solver = GurobiSolver(Presolve = 0))

        # 23 x 5 x staff binary assignment 3d matrix
        # 1 if employee k assigned to shift (i,j), 0 otherwise
        @variable(m, x[1:22, 1:5, 1:staff], Bin)

        # objective: rewards continuous shifts
        # special cases k = 1 (placeholder)
        #               k = 2 (Senior CA)

        @objective(m, Max,
            sum(av_matrix[i, j, k] * x[i, j, k] +
                x[i, j, k]  * (10 * av_matrix[i + 1, j, k] * x[i + 1, j, k]
                            +  10 * av_matrix[i - 1, j, k] * x[i - 1, j, k])
                for i in 2:21, j in 1:5, k in 3:staff)
            # special cases k = 1,2
            + sum(av_matrix[i, j, k] * x[i, j, k] for i in 1:22, j in 1:5, k in 1:2))

        # constraints

        # cons1: each person (except special cases k = 1,2) works 10hrs per week
        for k in 3:staff
            @constraint(m, sum(x[i, j, k] for i in 1:22, j in 1:5) == 20)
        end

        # cons1.1: senior CA = 2 works max 13hrs per week (no min)
        @constraint(m, sum(x[i, j, 2] for i in 1:22, j in 1:5) <= 26)

        # cons1.2: senior CA = 2 works max 2 opening/closing shifts
        @constraint(m, sum(x[i, j, 2] for i in [1, 22], j in 1:5) <= 2)

        # cons2: 1-2 people working at any given time
        #   exceptions: opening/closing
        #               weekly CA meeting (Wed 16:00-17:30)
        for i in 2:21
            for j in 1:5
                if j == 3 && i in 17:19 # (Wed 16:00-17:30)
                    continue
                else
                    @constraint(m, sum(x[i, j, k] for k in 1:staff) <= 2)
                    @constraint(m, sum(x[i, j, k] for k in 1:staff) >= 1)
                end
            end
        end

        # cons2.1: 1 person per opening or closing shift
        for i in [1, 2, 21, 22]
            for j in 1:5
                @constraint(m, sum(x[i, j, k] for k in 1:staff) == 1)
            end
        end

        # cons2.2: all CAs attend weekly meeting (Wed 16:00-17:30)
        for i in 17:19
            for k in 2:staff
                @constraint(m, x[i, 3, k] == 1)
            end
        end

        # cons3: each shift is at least 1hr
        for i in 2:21
            for j in 1:5
                for k in 1:staff
                    @constraint(m, x[i - 1, j, k] + x[i + 1, j, k] >= x[i, j, k])
                end
            end
        end

        # cons3.1: edge cases
        for j in 1:5
            for k in 1:staff
                @constraint(m, x[2, j, k] >= x[1, j, k])
                @constraint(m, x[21, j, k] >= x[22, j, k])
            end
        end

        # !!! cons4: each shift is at most 4hrs (may be unnecessary)

        status = solve(m)

        println("Objective value: ", getobjectivevalue(m))
        assn_array_3d = Array{Int64}(getvalue(x))

        # create final assignment array
        assn_array_2d       = Array{Array{Int64, 1}}(undef, 22, 5)
        assn_array_2d_names = Array{Array{String, 1}}(undef, 22, 5)

        # flatten 3d matrix into 2d array
        for i in 1:22
            for j in 1:5
                staff_in_ij         = []
                staff_in_ij_names   = []
                for k in 1:staff
                    if assn_array_3d[i, j, k] == 1
                        push!(staff_in_ij, k)
                        push!(staff_in_ij_names, staff_dict[k])
                    end
                end
                assn_array_2d[i, j]         = staff_in_ij
                assn_array_2d_names[i, j]   = staff_in_ij_names
            end
        end

        display(assn_array_2d)

        # create new workbook with assignment matrix
        w = Workbook()
        s = createSheet(w, "Assignments")

        for i in 1:22
            r = createRow(s, i)
            for j in 1:5, k in 1:staff
                c = createCell(r, 7 * (k - 1) + j)
                setCellValue(c, assn_array_3d[i, j, k])
            end
        end

        write("assn-matrix.xlsx", w)

        #=
        Discussion:
            - better to have continous shift rather than
            preferred shifts?
                - change neutrals to 1 and adjust the preferences
                accordingly
            - 30 min shift latching onto the team meeting
                - special case requiring at least one hour shift
                before/after meeting
            - max 2 opening/closing pp?
            - reward having different people opening/closing
        =#
    end
end