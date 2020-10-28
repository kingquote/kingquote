using RDatasets
trees = dataset("datasets","trees")
x = trees[!, :Girth]
y = trees[!, :Height]

include("ML.jl")
using .ML

lina,linb = linear_regression(x, y, iterations=1000000, learning_rate=0.01)
anaa,anab = analytical_regression(x,y)

using Plots
scatter(x,y)
plot!(x,ML.univariate_predict.(x,anaa,anab))
plot!(x,ML.univariate_predict.(x,lina,linb))

X = Matrix(trees[!, [:Girth,:Height]])
Y = trees[!, :Volume]

Xout,A = linear_regression(X, Y, iterations=10000000, learning_rate=0.0001)
ML.multivariate_cost(Xout,Y,A)

#redo:
using RDatasets
include("ML.jl")
using Main.ML
trees = dataset("datasets","trees")
x = array2matrix(trees[!, :Girth])
y = array2matrix(trees[!, :Height])

@sk_import linear_model: LinearRegression
model = LinearRegression()
fit!(model, x, y)
scatter(x,y)
plot!(x -> model.coef_[1,1]*x+model.intercept_[1,1], minimum(x):0.1:maximum(x))

X = Matrix(trees[!, [:Girth,:Height]])
Y = array2matrix(trees[!, :Volume])
fit!(model, X, Y)
