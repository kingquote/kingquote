include("ML.jl")
using Main.ML
using ScikitLearn

@sk_import datasets: load_boston
house = load_boston()
X = house["data"]
Y = house["target"]
Xtrain, Ytrain, Xtest, Ytest = separate_data(X,Y)

Xout, A = linear_regression(Xtrain,Ytrain,iterations=100000,learning_rate=0.000001,lambda=10)
score = ML.multivariate_cost( hcat(ones(size(Xtest,1)),Xtest), Ytest, A)
myA = A

@sk_import linear_model: LinearRegression
model = LinearRegression()
fit!(model, Xtrain, Ytrain)
sklA = Array(hcat(model.intercept_, model.coef_)')

mine = ML.multivariate_cost( hcat(ones(size(Xtest,1)),Xtest), Ytest, myA, lambda = 0.5)
skls = ML.multivariate_cost( hcat(ones(size(Xtest,1)),Xtest), Ytest, sklA, lambda = 0.5)
#ok, my cost function must be bad..


@sk_import datasets: load_digits
digits = load_digits()
X = digits["data"]
X = ML.minmaxnormalize(X)
Y= digits["target"]
Xtrain, Ytrain, Xtest, Ytest = separate_data(X,Y)

Xout, A = logistic_regression(Xtrain, Ytrain, iterations = 100000, learning_rate = 0.000001)
ML.logistic_predict(Xout, A, assign_categories = true)
ML.logistic_predict(hcat(ones(size(Xtest,1)),Xtest), A, assign_categories = true)
ML.logistic_cost(Xout, Ytrain, A)
ML.logistic_cost(hcat(ones(size(Xtest,1)),Xtest), Ytest, A)
myA = A

@sk_import linear_model: LogisticRegression
model = LogisticRegression()
fit!(model, Xtrain, Ytrain)
sklA = Array(hcat(model.intercept_, model.coef_)')
ML.logistic_predict(Xout, sklA, assign_categories = true)
ML.logistic_predict(hcat(ones(size(Xtest,1)),Xtest), sklA, assign_categories = true)
ML.logistic_cost(Xout, Ytrain, sklA)
ML.logistic_cost(hcat(ones(size(Xtest,1)),Xtest), Ytest, sklA)
#my functions to make models are clearly bad, if not even broken, but at least i can use the ScikitLearn model to make actual predictions.

#we already used ScikitLearn here, so I won't redo it.