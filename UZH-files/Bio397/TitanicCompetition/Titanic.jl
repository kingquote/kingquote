#Code on GitHub: https://github.com/kingquote/kingquote/tree/main/UZH-files/Bio397/TitanicCompetition

path = "UZH-files\\Bio397\\TitanicCompetition\\"

include(path*"TitanicFunctions.jl")
using Main.TitanicFunctions
using Statistics
using Plots
using ScikitLearn
using CSV
using DataFrames
using Flux
using Flux: onecold, crossentropy, throttle, onehotbatch
using Base.Iterators: repeated
using StatsBase: sample
using DecisionTree
@sk_import ensemble: RandomForestClassifier
@sk_import model_selection: GridSearchCV

X_train, Y_train, nfeatures,  X_test, pNr_test = prepareData(path*"train.csv", path*"test.csv")

#different models:
X_train, Y_train, X_test = X_train', Y_train', X_test'
m1 = RandomForestClassifier()

best_score = 9999999
best_params = Dict()
best_model = m1
for i in 1:5
  parameters = Dict("n_estimators" => 70:80)
  gridsearch = GridSearchCV(m1, parameters, scoring = "f1")
  fit!(gridsearch, X_train, Y_train)
  this_score = gridsearch.best_score_
  if this_score < best_score
    best_params = gridsearch.best_params_
    best_model = gridsearch.best_estimator_
    best_score = this_score
  end
end
best_score
best_params

result = predict(best_model, X_test)

## Build a network. The output layer uses softmax activation.
model = Chain(
  Dense(nfeatures, 20, Flux.relu),
  Dense(20, 10, Flux.relu),
  Dense(10, 1),
  softmax
)

## cross entropy cost function
cost(x, y) = crossentropy(model(x), y)

opt = Descent(0.5)  # Choose gradient descent optimizer with alpha=0.005
dataset = repeated((X_train, Y_train), 2500)  
Flux.train!(cost, params(model), dataset, opt)

accuracy(x, y) = mean(model(x) .== y)
accuracy(X_train, Y_train)  

result = model(X_test)

result = result'
output = prepareOutput(result, pNr_test)
CSV.write(path*"test_output.csv", output)


