module ML

    using DataFrames
    using CSV
    using RDatasets
    using Statistics
    using Random

    include("homebrewfunctions.jl")
    include("datacleanupfunctions.jl")
    include("linear_regression.jl")
    include("logistic_regression.jl")

    function array2matrix(X::Array)
        return(reshape(X,(length(X),1)))
    end

    export onehotencode, safedropmissing, minmaxnormalize, linear_regression, analytical_regression, logistic_regression, separate_data, array2matrix

end