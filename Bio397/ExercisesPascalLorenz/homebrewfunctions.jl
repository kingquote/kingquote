function onehotencode(dfin::DataFrame, colnam::String; keepmissing = false)
    #takes a dataframe and the name of one of its columns as a string as input, and returns a dataframe that had the named column split up into new columns for each unique entry of the original column, and 0/1 as entries.
    
    df = deepcopy(dfin)
    #find column number
    nam = names(df)
    colnum = 0
    for i in 1:length(nam)
        if colnam == nam[i]
            colnum = i
            break
        end
    end
    if colnum == 0
        error("Column name not found!")
    end

    c = deepcopy(df[:,colnum])
    #avoid missing values in column to be split
    hadmissing = false
    for i in 1:length(c)
        if c[i] === missing
            hadmissing = true
            c[i] = "missing" 
        end
    end

    cats = unique(c)
    for catenr in 1:length(cats) #go through categories one by one
        arr = []
        catena = cats[catenr]
        for i in c #go through values, creating new arrays
            if i == catena
                push!(arr, 1)
            else
                push!(arr, 0)
            end
        end
        #add new array to dataframe
        df.temp = arr
        push!(nam, colnam*catena)
        rename!(df, nam)
    end
    select!(df, Not(colnam))

    #remove column regarding missing if requested (is done by default)
    if !keepmissing && hadmissing
        select!(df, Not(colnam*"missing"))
    end

    return(df)
end

function onehotencode(dfin::DataFrame, colnames::Array; keepmissing = false)
    df = deepcopy(dfin)
    km = copy(keepmissing)

    for name in colnames
        df = onehotencode(df, name, keepmissing = km)
    end
    return(df)
end

function onehotencode(dfin::DataFrame; keepmissing = false)
    df = deepcopy(dfin)
    km = keepmissing

    colnames = []
    for name in names(df)
        if isa(df[!,name], CategoricalArray)
            push!(colnames, name)
        end
    end

    onehotencode(df, colnames, keepmissing = km)
end
    
"""
Takes inputs, puts them in one dataframe, shuffles the rows, and splits it in 80% rows for training and 20% for testing the model.
"""
function separate_data(X,Y)
    all = hcat(X, Y)
    all = all[shuffle(1:end), :]
    border = Int64(round(0.8*size(all,1)))
    train = all[1:border, :]
    test = all[border:end,:]
    Xtrain = train[:, 1:end-1]
    Ytrain = train[:, end:end]
    Xtest = test[:, 1:end-1]
    Ytest = test[: , end:end]
    return(Xtrain,Ytrain,Xtest,Ytest)
end