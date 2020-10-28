function cleanmissing(dfin::DataFrame, colname::String ; method::String = "auto", summarymethod::String = "mean")
    error("function cleanmissing unfinished")
    #method can be drop, summary or auto (for now). Auto selects based on amount of rows containing missing values (more than 30%?)
    #summarymethod can be mean, median or mode.
    df = deepcopy(dfin)

    if method == "auto" #if more than 50 rows, try dropping. if more than 30% lost, undo that.
        if size(df)[1] < 50
            method = "summary"
        else
            df = dropmissing(df, colname)
            if size(df)[1] < 0.7*size(dfin)[1] #if too little left:
                df = deepcopy(dfin)
                method = "summary"
            else
                return(df)
            end
        end      
    end

    if method == "drop"
        df = dropmissing(df, colname)
        return(df)
    elseif method == "summary"
        if summarymethod == "mean"
            meanv = mean(df[!,colname])
            #do mean
        elseif summarymethod == "median"
            #do median
        elseif summarymethod == "mode"
            #do mode
        end
    end
end

function safedropmissing(dfin::DataFrame)
    df = deepcopy(dfin)
    startlen = size(df)[1]
    minlen = 0.7*startlen
    curlen = size(df)[1]
    
    while curlen > minlen
        arr = describe(df)[!,:nmissing]
        for pos in 1:length(arr)
            if arr[pos] === nothing
                arr[pos] = startlen
            elseif arr[pos] == 0
                arr[pos] =startlen
            end
        end
        togo = minimum(arr)
        if curlen-togo < minlen
            break
        else
            todrop = findfirst(arr -> arr==togo, arr)
            dropmissing!(df,todrop)
        end
        curlen = size(df)[1]
    end
    return(df)
end

function minmaxnormalize(dfin, colname)
    df = deepcopy(dfin)
    df[!,colname] = convert.(Float64,df[!,colname])
    column = df[!,colname]
    mini = minimum(column)
    maxi = maximum(column)
    for i in 1:length(column)
        df[i,colname] = (df[i,colname]-mini) / (maxi-mini)
    end
    return(df)
end

function minmaxnormalize(dfin::DataFrame, colnames::Array)
    df = deepcopy(dfin)
    for colname in colnames
        try
            df = minmaxnormalize(df, colname)
        catch
            error(colname*"failed")
        end
    end
    return(df)
end


function minmaxnormalize(dfin::Array)
    df = deepcopy(dfin)
    for col in 1:size(df, 2)
        try
            column = df[:,col]
            mini = minimum(column)
            maxi = maximum(column)
            for i in 1:length(column)
                if !(maxi == 0 && mini == 0)
                    df[i,col] = (df[i,col]-mini) / (maxi-mini)
                end
            end
        catch
            error("$col failed")
        end
    end
    return(df)
end