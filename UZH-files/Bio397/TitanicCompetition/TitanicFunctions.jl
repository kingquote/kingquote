module TitanicFunctions

    using Statistics
    using Plots
    using ScikitLearn
    using CSV
    using DataFrames
    using Flux
    using Flux: onecold, crossentropy, throttle, onehotbatch
    using Base.Iterators: repeated
    using StatsBase: sample

    

    function cleandata(ds)
        df = deepcopy(ds)
        select!(df, Not(["Name", "Ticket", "Cabin"]))
        df.Sex = df[:,"Sex"] .== "male"
        dropmissing!(df, :Embarked)
      
        missing_rows_Age = findall(ismissing.(df[!,:Age]))
        description_of_df = describe(df)
        mean_Age = description_of_df[4, 2]
        df[missing_rows_Age, :Age] .= mean_Age
        dropmissing!(df, :Age)
      
        missing_rows_Fare = findall(ismissing.(df[!,:Fare]))
        description_of_df = describe(df)
        mean_Fare = description_of_df[4, 2]
        df[missing_rows_Fare, :Fare] .= mean_Fare
        dropmissing!(df, :Fare)
      
      
        onehotEmbarked = onehotbatch(df.Embarked, ["S","C","Q"])'
        df.S = onehotEmbarked[:,1]
        df.C = onehotEmbarked[:,2]
        df.Q = onehotEmbarked[:,3]
        select!(df, Not(["Embarked"]))
      
        pNr = deepcopy(df)
        select!(pNr, "PassengerId")
        pNr = Matrix(pNr)
        select!(df, Not(["PassengerId"]))
      
        return(df, pNr)
    end
      
    function prepareData()
        ds = CSV.read("train.csv")
        ds2 = CSV.read("test.csv")
      
        df, pNr_train = cleandata(ds)
      
        y = deepcopy(df)
        select!(y, "Survived")
        y = Matrix(y)
      
        select!(df, Not(["Survived"]))
      
      
        X_train = Matrix(df)
        X_train = X_train'
        Y_train = convert.(Float32,y')
        nfeatures = size(X_train, 1)
        
        df2, pNr_test = cleandata(ds2)
        X_test = Matrix(df2)
        X_test = X_test'
      
        return(X_train, Y_train, nfeatures, X_test, pNr_test)
    end
      
    function prepareOutput(result, pNr_test)
        output = hcat(pNr_test, result')
        output = convert.(Int64, output)
        output = DataFrame(output)
        colnames = ["PassengerId","Survived"]
        names!(output, Symbol.(colnames))
    end

    export cleandata, prepareData, prepareOutput
    
end