include("ML.jl")
using Main.ML
using CSV
using DataFrames
using LinearAlgebra
using Statistics
using ScikitLearn
using Plots

#PCA:
@sk_import datasets: load_breast_cancer
all_data = load_breast_cancer()
X = all_data["data"]
y = all_data["target"]

function myPCA(Xin::Array, k::Number)
    X=deepcopy(Xin)
    #normalize and scale data
    X = minmaxnormalize(X)
    for feature in 1:size(X, 2)
        colmean = mean(X[:, feature])
        X[:, feature] = X[:, feature] .- colmean
    end

    #calculate covariance matrix covX
    covX = cov(X)

    #calculate eigenvectors of covX
    eigveccovX = eigvecs(covX)
    eigvalcovX = eigvals(covX)

    #pick last k (largest eigenvalues) for uk
    uk = eigveccovX[:, end-(k-1):end]
    
    #recast data
    outp = X * uk

    #calculate explained variance
    eigvalsum = sum(eigvalcovX)
    totexplvar = eigvalcovX ./ eigvalsum
    explvar = sum(totexplvar[end-(k-1):end])

    return(outp,explvar)
end

newX, explvar = myPCA(X,2)
explvar
scatter(newX[:,1], newX[:,2])

function PCA99(Xin::Array)
    X = deepcopy(Xin)
    explvar = 0
    k=0
    while explvar < 0.99
        k = k+1
        newX, explvar = myPCA(X,k)
    end
    return(newX, explvar, k)
end

newX, explvar, k = PCA99(X)
explvar
k


#Anomaly detection
@sk_import covariance: EllipticEnvelope
@sk_import datasets: make_moons
@sk_import datasets: make_blobs

n_samples = 300
outliers_fraction = 0.05
n_outliers = round(Int64, outliers_fraction * n_samples)
n_inliers = n_samples - n_outliers

X, y = make_blobs(centers=[[0, 0], [0, 0]], cluster_std=0.5, random_state=1, n_samples=n_inliers, n_features=2)

scatter(X[:, 1], X[:, 2], legend=false)

function calculateProbability(x::Number, colmean::Number, standardDeviation::Number)
    sd = standardDeviation
    p = (1 / (sd*sqrt(2*π)) ) * ℯ^((-0.5)*(((x-colmean)/sd)^2))
    return(p)
end

function detectanomaly(Xin::Array, threshold::Number; normalize::Bool = false)
    X = deepcopy(Xin)
    if normalize
        X = minmaxnormalize(X)
        for j in 1:size(X,2)
            column = X[:,j]
            X[:,j] = sqrt.(column)
        end
    end
    for j in 1:size(X, 2)
        column = X[:,j]
        colmean = mean(column)
        sd = std(column)
        X[:,j] = calculateProbability.(column,colmean,sd)
    end
    probs = zeros(size(X,1),1)
    for i in 1:size(X,1)
        probs[i] = prod(X[i, :])
    end
    X = deepcopy(Xin)
    outliers = zeros(0,size(X,2))
    indexes = []
    for i in 1:size(X,1)
        if probs[i] < threshold
            outliers = vcat(outliers, X[i,:]')
            indexes = vcat(indexes, i)
        end
    end
    return(outliers, indexes)
end

outliers = detectanomaly(X, 0.05)

scatter(X[:, 1], X[:, 2])
scatter!(outliers[:,1], outliers[:,2])


#testing anomaly detection with high dimensional input
X = all_data["data"]
outliers, indexes = detectanomaly(X, 0.05, normalize = true)
newX, explvar = PCA(X, 2)

outliers = zeros(0, size(newX, 2))
for index in indexes
    outliers = vcat(outliers, newX[index,:]')
end

scatter(newX[:,1], newX[:,2])
scatter!(outliers[:,1], outliers[:,2])


#redo:
include("ML.jl")
using Main.ML
using CSV
using DataFrames
using LinearAlgebra
using Statistics
using ScikitLearn
using Plots

#PCA:
@sk_import datasets: load_breast_cancer
all_data = load_breast_cancer()
X = all_data["data"]
y = array2matrix(all_data["target"])

@sk_import decomposition: PCA
@sk_import preprocessing: RobustScaler

scaler = RobustScaler()
fit_transform!(RobustScaler, X)

decomp2 = PCA(n_components=2)
decomp99 = PCA(n_components=0.99, svd_solver="full")

newX = fit_transform!(decomp2, X, y)
sum(decomp2.explained_variance_ratio_)
scatter(newX[:,1], newX[:,2])

fit!(decomp99, X, y)
decomp99.n_components_
sum(decomp99.explained_variance_ratio_)

#Anomaly Detection:
@sk_import covariance: EllipticEnvelope
@sk_import datasets: make_moons
@sk_import datasets: make_blobs

n_samples = 300
outliers_fraction = 0.05
n_outliers = round(Int64, outliers_fraction * n_samples)
n_inliers = n_samples - n_outliers

X, y = make_blobs(centers=[[0, 0], [0, 0]], cluster_std=0.5, random_state=1, n_samples=n_inliers, n_features=2)

detectElli = EllipticEnvelope()
indexes = fit_predict!(detectElli, X)

outliers = zeros(0, size(X, 2))
for i in 1:size(indexes,1)
    if indexes[i] == -1
        outliers = vcat(outliers, X[i,:]')
    end
end

scatter(X[:,1], X[:,2])
scatter!(outliers[:,1], outliers[:,2])