using Plots
using DataFrames
using VegaDatasets

function manuallinearfit(a,b)
    df = DataFrame(VegaDatasets.dataset("cars"))
    dfx = df.Weight_in_lbs
    mini = minimum(dfx)
    maxi = maximum(dfx)
    dfy = df.Displacement
    scatter(dfx,dfy)
    plot!(x -> a*x+b, mini:0.1:maxi)
end

manuallinearfit(0.12,-150) #found by trying

function SSR(ys, yps)
    total = 0
    for i in 1:length(ys)
        total = total + ((ys[i]-yps[i])^2)
    end
    return(total)
end

function linearfit(;noplot=true)
    df = DataFrame(dataset("cars"))
    dfx = df.Weight_in_lbs
    dfy = df.Displacement
    mini = minimum(dfx)
    maxi = maximum(dfx)
    x = mini:((maxi-mini)/length(dfx)):maxi
    besteval = 999999999
    best = [1, 0]
    for i in 1:99999
        a = rand()
        b = rand()
        y = a .* x .+ b
        eval = SSR(dfy,y)
        if eval < besteval
            best = [a, b]
            besteval = eval
        end
    end
    if noplot
        return(best)
    end
    scatter(dfx,dfy)
    y = best[1] .* dfx .+ best[2]
    plot!(dfx,y)
end
linearfit()

#redo:
using ScikitLearn
using Plots
using DataFrames
using VegaDatasets
df = DataFrame(VegaDatasets.dataset("cars"))
dfx = df.Weight_in_lbs
dfy = df.Displacement
X=zeros(length(dfx),1)
y=zeros(length(dfy),1)
X[:,1] = dfx
y[:,1] = dfy

@sk_import linear_model: LinearRegression
model = LinearRegression()
fit!(model, X, y)
#just using this for plotting:
manuallinearfit(model.coef_[1,1], model.intercept_[1,1])