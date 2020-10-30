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
        avail_top_left_row = header_thickness + 1 #+1 because "the next row"
        staffnum_location = (spacing_to_staff_number, nshifts + avail_top_left_row + tables_to_info)
        avail_bot_right_row = nshifts + header_thickness
        avail_table_distance = nworkdays + table_separator_width + 1 #+1 for column with times


        Taro.init()

        # number of staff (staffnum_location on sheet (eg. B27 -> (2,27)))
        staff = Integer(getCellValue(getCell(getRow(getSheet(
                    Workbook(input_path), availability_sheet_name), staffnum_location[2]), staffnum_location[1])))

        # get staff availability tables
        # top left cell on row 2, bot right cell on row avail_bot_right_row
        # each table separated by avail_table_distance cells

        staff_array = []                        # with preference/availability data
        staff_dict  = Dict{Integer, String}()   # with names of staff

        for i in 0:staff - 1
            range = string(numtocol(avail_table_distance * i + 2),
                            "2:",
                            numtocol(avail_table_distance * i + 6),
                            string(avail_bot_right_row))
            push!(staff_array,
                DataFrame(Taro.readxl(input_path, availability_sheet_name,
                range, header = false)))
            staff_dict[i + 1] = String(getCellValue(getCell(getRow(getSheet(
                Workbook(input_path), availability_sheet_name), 0), avail_table_distance * i)))
        end

        # create 3D availability array
        av_matrix = Array{Int8}(undef, nshifts, nworkdays, staff)

        for k in 1:staff
            for i in 1:nshifts
                for j in 1:nworkdays
                    av_matrix[i,j,k] = Matrix(staff_array[k])[i,j]
                end
            end
        end

        # optimization model
        m = Model(Gurobi.Optimizer)
        set_optimizer_attribute(m, "Presolve", 0)

        # nshifts x nworkdays x staff binary assignment 3d matrix
        # 1 if employee k assigned to shift (i,j), 0 otherwise
        @variable(m, x[1:nshifts, 1:nworkdays, 1:staff], Bin)

        # objective: rewards continuous shifts
        # special case k = 1 (placeholder)

        @objective(m, Max,
            sum(av_matrix[i, j, k] * x[i, j, k] +
                x[i, j, k]  * (10 * av_matrix[i + 1, j, k] * x[i + 1, j, k]
                            +  10 * av_matrix[i - 1, j, k] * x[i - 1, j, k])
                for i in 2:(nshifts-1), j in 1:nworkdays, k in 2:staff)
            # special cases k = 1
            + sum(av_matrix[i, j, k] * x[i, j, k] for i in 1:nshifts, j in 1:nworkdays, k in 1:1))

        # constraints

        # cons1: each person (except special cases k = 1,2) works 10hrs per week
        for k in 2:staff
            @constraint(m, sum(x[i, j, k] for i in 1:nshifts, j in 1:nworkdays) == 20)  
        end

        # cons1.1: senior CA = 2 works max 13hrs per week (no min)
        #@constraint(m, sum(x[i, j, 2] for i in 1:nshifts, j in 1:nworkdays) <= 26)

        # cons1.2: senior CA = 2 works max 2 opening/closing shifts
        #@constraint(m, sum(x[i, j, 2] for i in [1, nshifts], j in 1:nworkdays) <= 2)

        # cons2: 1-2 people working at any given time
        #   exceptions: opening/closing
        #               weekly CA meeting (Wed 16:00-17:30)
        for i in 2:(nshifts-1)
            for j in 1:nworkdays
                if j == 3 && i in 17:19 # (Wed 16:00-17:30)
                    continue
                else
                    @constraint(m, sum(x[i, j, k] for k in 1:staff) <= 2)
                    @constraint(m, sum(x[i, j, k] for k in 1:staff) >= 1)
                end
            end
        end

        # cons2.1: 1 person per opening or closing shift
        for i in [1, 2, (nshifts-1), nshifts]
            for j in 1:nworkdays
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
        for i in 2:(nshift-1)
            for j in 1:nworkdays
                for k in 1:staff
                    @constraint(m, x[i - 1, j, k] + x[i + 1, j, k] >= x[i, j, k])
                end
            end
        end

        # cons3.1: edge cases
        for j in 1:nworkdays
            for k in 1:staff
                @constraint(m, x[2, j, k] >= x[1, j, k])
                @constraint(m, x[(nshifts-1), j, k] >= x[nshifts, j, k])
            end
        end

        # !!! cons4: each shift is at most 4hrs (may be unnecessary)

        status = optimize!(m)

        println("Objective value: ", getobjectivevalue(m))
        assn_array_3d = Array{Int64}(getvalue.(x))

        # create final assignment array
        assn_array_2d       = Array{Array{Int64, 1}}(undef, nshifts, nworkdays)
        assn_array_2d_names = Array{Array{String, 1}}(undef, nshifts, nworkdays)

        # flatten 3d matrix into 2d array
        for i in 1:nshifts
            for j in 1:nworkdays
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
        s = createSheet(w, assignment_sheet_name)

        for i in 1:nshifts
            r = createRow(s, i)
            for j in 1:nworkdays, k in 1:staff
                c = createCell(r, avail_table_distance * (k - 1) + j)
                setCellValue(c, assn_array_3d[i, j, k])
            end
        end

        write(output_path, w)

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