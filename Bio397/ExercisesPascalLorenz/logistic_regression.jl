"""
    function logistic_regression(Xin, Yin, iterations = 10000, learning_rate = 0.1)

Trains a model on the given data and returns its coefficients and intercept, as well as the modified X it uses.
"""
function logistic_regression(Xin::Array, Yin::Array; iterations::Number=10000, learning_rate::Number=0.1)
    X = deepcopy(Xin)
    Y = deepcopy(Yin)
    X = hcat(ones(length(Y)), X)
    categories = sort(unique(Y))
    A = zeros(size(X, 2), length(categories))
    for n in 1:length(categories)
        tempA = ones(size(X, 2), 1) ./ 2
        testY = Y .== categories[n]
        for i in 1:iterations
            tempA = logistic_gradient(X,Y,tempA,learning_rate=learning_rate)
        end
        A[:,n] = tempA
    end
    return(X, A)
end

"""
    logistic_gradient(X, Y, A, learning_rate=0.1)

Returns a new Array for A using the derivative of the cost function of logistic regression.
"""
function logistic_gradient(X::Array, Y::Array, A::Array; learning_rate::Number=0.1)
    Ypred = logistic_predict(X, A)
    gradA = (.-(Y .- Ypred)' * X ) / length(Y)

    A = A  - (learning_rate * gradA')
    return(A)
end

"""
    logistic_predict(X, A, assign_categories = false, categories = [])

Returns the prediction of a logistic model with multiple variables as an array in X. The array 'A' contains the model parameters.
If assign_categories is true, also pass in the category names in an array! Otherwise they will just be numbered.
"""
function logistic_predict(X::Array, A::Array; assign_categories::Bool = false, categories::Array = [])
    Y = 1 ./ (1 .+ exp.(-(X * A)))
    if assign_categories
        if categories == []
            categories = Array(1:size(Y,2))
        end
        Yout = zeros(size(Y,1),1)
        for i in 1:size(Y,1)
            Yout[i] = categories[findmax(Y[i,:])[2]]
        end
        return(Yout)
    else
        return(Y)
    end
end

"""
    logistic_cost(X, Y, A)

Returns the cost of the logistic  model with parameters 'A'.
"""
function logistic_cost(X::Array, Y::Array, A::Array)
    Ypred = logistic_predict(X, A)
    c = mean(Y .* log.(Ypred) .+ (1 .- Y) .* log.(1 .- Ypred))
    return(c)
end


