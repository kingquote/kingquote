"""
    univariate_predict(x, a, b)

Returns the prediction of a linear model with one variable `x`. `a` and `b` are model parameters.
"""
function univariate_predict(x::Number, a::Number, b::Number)
    y = a * x + b
    return(y)
end

"""
    multivariate_predict(X, A)

Returns the prediction of a linear model with multiple variables as an array in X. The array 'A' contains the model parameters.
"""
function multivariate_predict(X::Array, A::Array)
    Y = X*A
    return(Y)
end

"""
    univariate_gradient(X, Y, a, b, learning_rate=0.1)

Returns a new value for `a` and `b` using the derivative of the cost function of linear regression.
"""
function univariate_gradient(X::Array, Y::Array, a::Number, b::Number; learning_rate::Number=0.1)
    Ypred = univariate_predict.(X, a, b)

    grada = mean(.-(Y.-Ypred).*X)
    gradb = mean(.-(Y.-Ypred))

    a = a - learning_rate * grada
    b = b - learning_rate * gradb
    return(a,b)
end

"""
    multivariate_gradient(X, Y, A, learning_rate=0.1, lambda = 0)

Returns a new Array for A using the derivative of the cost function of linear regression. Lambda is for Ridge normalization.
"""
function multivariate_gradient(X::Array, Y::Array, A::Array; learning_rate::Number=0.1, lambda::Number = 0)
    Ypred = multivariate_predict(X, A)
    gradA = ((Ypred .- Y)'/length(Y)) * X
    normA = 1 - (learning_rate * lambda / length(Y))

    A = (A * normA) - (learning_rate * gradA')
    return(A)
end

"""
    univariate_cost(X, Y, a, b)

Returns the cost of the linear model with parameters `a` and `b`.
"""
function univariate_cost(X::Array, Y::Array, a::Number, b::Number)
    c = 0
    Ypred = univariate_predict.(X, a, b)
    for i in 1:length(X)
        c = c + ((Y[i] - Ypred[i])^2)
    end
    return(c)
end

"""
    multivariate_cost(X, Y, A, lambda = 0)

Returns the cost of the linear model with parameters 'A'. Lambda is the modifier for Ridge normalization. The default zero means no normalization.
"""
function multivariate_cost(X::Array, Y::Array, A::Array; lambda::Number = 0)
    reg = lambda * (sum(A.^2)-1) #-1 to remove the 1^2 of the bias
    c = sum((X*A-Y).^2 .+ reg)/(2*length(Y))
    return(c)
end

"""
    GD(X, Y; iterations=10000, learning_rate=0.1, lambda = 0)

Returns parameters of a univariate linear model (`a`, and `b`) using gradient descent. Lambda is for ridge normalization.
"""
function linear_regression(Xin::Array, Yin::Array; iterations::Number=10000, learning_rate::Number=0.1, lambda::Number = 0)
    X = deepcopy(Xin)
    Y = deepcopy(Yin)
    if length(size(X)) == 1
        a=1
        b=1
        for i in 1:iterations
            a,b = univariate_gradient(X,Y,a,b,learning_rate=learning_rate)
        end
        return(a,b)
    else
        X = hcat(ones(length(Y)), X)
        A = ones(size(X)[2],1) 
        for i in 1:iterations
            A = multivariate_gradient(X,Y,A,learning_rate=learning_rate, lambda=lambda)
        end
        return(X, A)
    end
end

"""
analytical solution for a and b based on X and Y
"""
function analytical_regression(X::Array, Y::Array)
    meanY = mean(Y)
    meanX= mean(X)

    topofa = 0
    bottomofa = 0
    for i in 1:length(X)
        topofa = topofa + (X[i] * Y[i] - meanY * X[i])
        bottomofa = bottomofa + (X[i]^2 - meanX * X[i])
    end
    a = topofa / bottomofa

    b = meanY - a * meanX
    
    return(a,b)
end