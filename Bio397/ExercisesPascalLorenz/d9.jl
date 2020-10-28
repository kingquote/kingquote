using Flux
using Flux: onehotbatch, onecold
using ScikitLearn
using Statistics

# Load the data
@sk_import datasets: load_digits
@sk_import model_selection: train_test_split
digits = load_digits();
X = Float32.(transpose(digits["data"]));  # make the X Float32 to save memory
y = digits["target"];
Y = Int32.(onehotbatch(y, 0:9));

#Split the data between test and training.
X_train, X_test, Y_train, Y_test = train_test_split(X', Y', train_size=0.8)
X_train, X_test, Y_train, Y_test = X_train', X_test', Y_train', Y_test'


#Write a linear line function that accepts data X, slopes W (same is A in linear regression), and intercepts b. The function uses the arguments in a linear line equation.
function manlinline(X, W, b)
    res = W * X .+ b
    return(res)
end

#Write two activation functions: ReLu for inner layers, and logistic for the output layer. These functions can be defined for a single number. You would use broadcasting to apply them to arrays.
function manReLu(z)
    return(maximum((0.01*z, z)))
end
function manlog(z)
    return(1 / (1 + ℯ^(-z)))
end

#Write a function that makes predictions given the data X, and all model parameters. This will be simply use the linear and activation functions you have defined.
manmakepred(X, W1, b1, W2, b2, W3, b3) = manlog.(manlinline(manReLu.(manlinline(manReLu.(manlinline(X, W1, b1)), W2, b2)), W3, b3))

#Write a cost function that takes two numbers, actual and predicted y, and returns a cost. This can be the same as the logistic cost function.
function mancost(y::Number, ypred::Number)
    return((-y * log(ypred)) - ((1 - y) * log(1 - ypred)))
end

#Write another cost function that accepts all your neural network parameters as arguments. Then, it makes a prediction. Finally it uses the previous cost function with broadcasting to calculate the cost of all predictions.
function mancost(X, Y, W1, b1, W2, b2, W3, b3)
    pred = manmakepred(X, W1, b1, W2, b2, W3, b3)
    cost = mean(mancost.(Y, pred))
    return(cost)
end

#Finally, write a function that uses gradient descent algorithm to tune the parameters. You can use automatic differentiation to get the gradient of the cost function with respect to each parameter:
function mantune(X, Y; alpha = 0.1, iterations = 1000)
    #initialize Ws & bs
    W1 = rand(20, size(X,1)) .* 0.01
    W2 = rand(15, 20) .* 0.01
    W3 = rand(10, 15) .* 0.01
    b1 = zeros(20, 1)
    b2 = zeros(15, 1)
    b3 = zeros(10, 1)

    for iter in 1:iterations
        #get gradients:
        grads = gradient(() -> mancost(X, Y, W1, b1, W2, b2, W3, b3), params(W1, b1, W2, b2, W3, b3))

        #adjust parameters
        W1 = W1-alpha*grads[W1]
        b1 = b1-alpha*grads[b1]
        W2 = W2-alpha*grads[W2]
        b2 = b2-alpha*grads[b2]
        W3 = W3-alpha*grads[W3]
        b3 = b3-alpha*grads[b3]
    end
    cost = mancost(X, Y, W1, b1, W2, b2, W3, b3)
    return(W1,b1,W2,b2,W3,b3,cost)
end

## training:
## WARNING: It will take 40mins to finish with this many iterations! Lower them if you just want to go through the code, but a high number is needed for a decent model.
W1,b1,W2,b2,W3,b3,cost = mantune(X_train, Y_train, alpha=0.5, iterations=2000)
cost

#After your network is trained, make predictions on X_test. What is the accuracy of your algorithm?
pred = manmakepred(X_test, W1, b1, W2, b2, W3, b3)
cost = mean(mancost.(Y_test, pred))

accuracy = mean(onecold(pred) .== onecold(Y_test))
accuracy #about 96%, but takes a very long time



#provided solution with Flux:
using Flux
using Flux: onecold, crossentropy, throttle, onehotbatch
using ScikitLearn
using Base.Iterators: repeated
using StatsBase: sample

@sk_import datasets: load_digits
@sk_import model_selection: train_test_split
digits = load_digits();
X = Float32.(transpose(digits["data"]));  # make the X Float32 to save memory
y = digits["target"];
Y = Int32.(onehotbatch(y, 0:9));
nfeatures, nsamples = size(X)

## Split train and test
X_train, X_test, y_train, y_test = train_test_split(X', y, train_size=0.81, test_size=0.19, random_state=3, stratify=y)
X_train = X_train'
X_test = X_test'

## One hot encode y
Y_train = onehotbatch(y_train, 0:9)
Y_test = onehotbatch(y_test, 0:9)

## Build a network. The output layer uses softmax activation, which suits multiclass classification problems.
model = Chain(
  Dense(nfeatures, 20, Flux.relu),
  Dense(20, 15, Flux.relu),
  Dense(15, 10),
  softmax
)

## cross entropy cost function
cost2(x, y) = crossentropy(model(x), y)

opt = Descent(0.005)  # Choose gradient descent optimizer with alpha=0.005
dataset = repeated((X_train, Y_train), 2000)  # repeat the dataset 2000 times, equivalent to running 2000 iterations of gradient descent
Flux.train!(cost2, params(model), dataset, opt)

accuracy2(x, y) = mean(onecold(model(x)) .== onecold(y))
accuracy2(X_test, Y_test)  #over 90%, and in a fraction of the time my own took
