include("ML.jl")
using Main.ML
using CSV
using DataFrames
using PyPlot
using ScikitLearn
using Random


#K nearest neighbors, KNN
f = open("name_gender.txt")
df = CSV.read(f, header=["Name","Gender"])
close(f)

function vectorize(name)
    name = lowercase(name)
    temp=[0,0,0,0,0]
    temp[1] = length(name)
    temp[2] = sum([count("a",name), count("e",name), count("i",name), count("o",name), count("u",name)])
    temp[3] = sum([count("b",name), count("d",name), count("g",name), count("p",name), count("t",name), count("k",name)])
    temp[4] = name[begin]
    temp[5] = name[end]
    return(temp)
end

X = zeros(length(df[:,1]), 5)
for i in 1:size(X,1)
    name = df[i,1]
    X[i,1:5] = vectorize(name)
end

function namesKNN(k, name)
    nameX = vectorize(name)
    temp = hcat(zeros(size(df,1)), df[:,2])
    for j in 1:size(X,1)
        temp[j,1] = sqrt(sum((nameX .- X[j,:]).^2))
    end
    temp = DataFrame(temp)
    temp = sort(temp, 1)
    cats = unique(temp[1:k,2])
    cats = hcat(cats, zeros(length(cats),))
    for j in 1:size(cats,1)
        cat = cats[j,1]
        counter = 0
        for i in 1:k
            if temp[i,2] == cat
                counter = counter+1
            end
        end
        cats[j,2] = counter
    end
    n, pos = findmax(cats[:,2])
    cat = cats[pos,1]
    certainty = n/k
    return(cat, certainty)
end

namesKNN(101, "Pascal")
namesKNN(101, "Pascale")


#K-means
@sk_import datasets: make_blobs
features, labels = make_blobs(n_samples=500, centers=3, cluster_std=0.55, random_state=0)
 
scatter(features[:, 1], features[:, 2], color="black")

function k_means_cost(Xin, centroids)
    X = deepcopy(Xin)
    centr = deepcopy(centroids)
    if size(X, 2) == size(centr, 2) #X should have one extra column for the assignment. This must be unassigned.
        X = assign2centr(X, centr)
    end
    total = 0
    for i in size(X,1)
        cen = Int64(X[i, end])
        temp = sum((centr[cen,:] .- X[i,1:end-1]).^2)
        total = total + temp
    end
    outp = total/size(X,1)
    return(outp)
end

function assign2centr(Xin, centroids)
    X = deepcopy(Xin)
    centr = deepcopy(centroids)
    if size(X, 2) == size(centr, 2) #X should have one extra column for the assignment. This must be the first time we assign it.
        X = hcat(X, zeros(size(X,1),))
    end
    for i in 1:size(X, 1)
        closest = (0, 999999999999999)
        for cen in 1:size(centr,1)
            dist = sqrt(sum((centr[cen,:] .- X[i,1:end-1]).^2))
            if dist < closest[2]
                closest = (cen, dist)
            end
        end
        X[i, end] = closest[1]
    end
    return(X)
end

function k_means(Xin, k; outer_iterations = 50, inner_iterations = 5000)
    bestscore = 9999999999999
    bestcentr = zeros(k, size(Xin,2))
    assignedX = zeros(size(Xin,1), size(Xin,2)+1)
    for outiter in 1:outer_iterations
        X = deepcopy(Xin)
        #initialize centroids
        centr = copy(X[shuffle(1:end), :][1:k, :])
        for initer in 1:inner_iterations
            #assign to centroid
            X = assign2centr(X, centr)
            #move centroids
            for cen in 1:size(centr,1)
                total = zeros(size(centr,2),)
                counter = 0
                for i in 1:size(X, 1)
                    if X[i, end] == cen
                        total = total + X[i,1:end-1]
                        counter = counter+1
                    end
                end
                centr[cen,:] = total ./ counter
            end
        end
        thisscore = k_means_cost(X, centr)
        if thisscore < bestscore
            bestscore = thisscore
            bestcentr = centr
            assignedX = X
        end
    end
    return(bestscore, bestcentr, assignedX)
end

k_means(features, 3)


#Mean Shift
function weigh(distance, lambda)
    weight = 0
    if distance < lambda
        weight = 1
    end
    return(weight)
end

function shift(p, Xin, lambda)
    X = deepcopy(Xin)
    sums = zeros(size(p))
    for i in size(X,1)
        comp = X[i,:]
        dist = sqrt(sum((p .- comp).^2))
        weight = weigh(dist, lambda)
        sums = sums + (weight * comp)
    end
    newp = sums / size(X,1)
    return newp
end

function mean_shift(X, lambda, threshold)
    centr = zeros(0, size(X,2))
    for i in 1:size(X,1)
        copy = deepcopy(X)
        p = X[i,:]
        working = true
        while working
            pnew = shift(p,X,lambda)
            shiftsize = sqrt(sum((p .- pnew).^2))
            p = pnew
            if shiftsize < threshold
                if size(centr, 1) !== 0
                    mincentdist = 999999999999
                    for j in 1:size(centr,1)
                        centdist = sqrt(sum((p .- centr[j,:]).^2))
                        if centdist < mincentdist
                            mincentdist = centdist
                        end
                    end
                    if mincentdist < threshold
                        working = false
                    end
                elseif working
                    centr = vcat(centr, p')
                    working = false
                end
            end
        end
    end
    return(centr)     
end

features, labels = make_blobs(n_samples=500, centers=3, cluster_std=0.55, random_state=0)

mean_shift(features, 1000, 0.00001)





#redo:
include("ML.jl")
using Main.ML
using CSV
using DataFrames
using PyPlot
using ScikitLearn
using Random

#KNN
f = open("name_gender.txt")
df = CSV.read(f, header=["Name","Gender"])
close(f)

function vectorize(name)
    name = lowercase(name)
    temp=[0,0,0,0,0]
    temp[1] = length(name)
    temp[2] = sum([count("a",name), count("e",name), count("i",name), count("o",name), count("u",name)])
    temp[3] = sum([count("b",name), count("d",name), count("g",name), count("p",name), count("t",name), count("k",name)])
    temp[4] = name[begin]
    temp[5] = name[end]
    return(temp)
end

X = zeros(length(df[:,1]), 5)
for i in 1:size(X,1)
    name = df[i,1]
    X[i,1:5] = vectorize(name)
end
y=convert(Array, df[:,2])
y = y.=="male"

@sk_import neighbors: KNeighborsClassifier
@sk_import preprocessing: RobustScaler
@sk_import model_selection: StratifiedKFold
@sk_import model_selection: GridSearchCV


scaler = RobustScaler()
X = fit_transform!(scaler, X)

model = KNeighborsClassifier()
parameters = Dict("n_neighbors" => 1:2:30, "weights" => ("uniform", "distance"))
kf = StratifiedKFold(n_splits=5, shuffle=true)
gridsearch = GridSearchCV(model, parameters, scoring="f1", cv=kf)
fit!(gridsearch, X, y)
bestmodel = gridsearch.best_estimator_

testnames=["Pascal", "Pascale", "MaiAnh", "Duc"]
testvectors = zeros(length(testnames), size(X,2))
for i in 1:length(testnames)
    testvectors[i,:] = vectorize(testnames[i])
end
testvectors = fit_transform!(scaler, testvectors)
bestmodel.predict

#K-means:
@sk_import datasets: make_blobs
features, labels = make_blobs(n_samples=500, centers=3, cluster_std=0.55, random_state=0)

@sk_import cluster: KMeans
scaler = RobustScaler()
X = fit_transform!(scaler, X)

model = KMeans()
parameters = Dict("n_clusters" => 5:15, "n_init" => 5:15)
gridsearch = GridSearchCV(model, parameters, scoring="f1")
fit!(gridsearch, features, labels)


#Mean shift
@sk_import cluster: MeanShift
features, labels = make_blobs(n_samples=500, centers=3, cluster_std=0.55, random_state=0)

scaler = RobustScaler()
fit_transform!(scaler, X)

model = MeanShift()
parameters = Dict("bandwidth" => 0.000001:0.01:1)
gridsearch = GridSearchCV(model, parameters, scoring="f1")
fit!(gridsearch, features, labels)