#1) Write a function that takes a string as its input and returns the string from backward.
function flipString(inp::String)
    outp = ""
    len = length(inp)
    for pos in 1:len
        outp = outp*inp[len-pos+1]
    end
    return(outp)
end

flipString("Hello World!")

#2) Write a function that checks whether a string is palindromic (the string is the same whether read from backward or forward).
function isPalindrome(inp::String)
    flip = flipString(inp)
    if inp==flip
        print("$inp is a palindrome")
    else
        print("$inp is NOT a palindrome")
    end
end

isPalindrome("Hello World!")
isPalindrome("abcdcba")

#3) Write a single function that counts the number of elements of its input, whether the input is an array or a string. Then, it should return a new element that is of the same type as its input but with duplicate elements.
function doubleUp(inp)
    len = length(inp)
    if typeof(inp) == String
        outp = ""
        for pos in 1:len
            outp = outp*inp[pos]*inp[pos]
        end
    else
        outp = []
        for pos in 1:len
            push!(outp, inp[pos])
            push!(outp, inp[pos])
        end
    end
    return(outp)
end

doubleUp("Hello World!")
doubleUp([1,2,3,4])

#4)Write a function called nestedsum that takes an array of arrays of integers and adds up the elements from all of the nested arrays. For example:
#julia> t = [[1, 2], [3], [4, 5, 6]];
#
#julia> nestedsum(t)
#21
function nestedsum(inp::Array)
    sum = 0
    for i in 1:length(inp)
        if isa(inp[i], Array)
            sum = sum + nestedsum(inp[i])
        else
            sum = sum + inp[i]
        end
    end
    return(sum)
end

nestedsum([[1, 2], [3], [4, 5, 6]])

#5)Write a function that checks whether an array has duplicates. Then write another function that returns the duplicate values and indices.
function hasDupli(inp::Array)
    for i in 1:length(inp)-1
        for j in i+1:length(inp)
            if inp[i] == inp[j]
                return(true)
            end
        end
    end
    return(false)
end

hasDupli([1,2,3,4])
hasDupli([1,2,3,4,4])

function giveDupli(inp::Array)
    if !hasDupli(inp)
        return([])
    else
        outp = []
        for i in 1:length(inp)-1
            for j in i+1:length(inp)
                if inp[i] == inp[j]
                    push!(outp, (i,j,inp[i]))
                end
            end
        end
        return(outp)
    end
end

giveDupli([1,10,22,10,22])

#6)Create an object named Point which has two number fields: ‘x’ and ‘y’. Create another object named Circle with fields center and radius, where center is itself a Point object and radius is a number. Now write a function named area that accepts a Circle object as its inputs and returns the area of the circle. Create another object named Square with a single number field called side. Finally, create a new method for the area function. This time, a function with the same name, but accepts a Square object and returns its area. Test your functions with some instances of a Square and Circle objects.
mutable struct Point
    x::Number
    y::Number
end
mutable struct Circle
    center::Point
    radius::Number
end
mutable struct Square
    side::Number
end
function area(inp::Circle)
    r = inp.radius
    a = π*(r^2)
    return(a)
end
function area(inp::Square)
    s = inp.side
    a = s^2
    return(a)
end

circle = Circle(Point(12,43),3)
area(circle)
square = Square(4)
area(square)

#7)Put your Circle and Square object definitions in a file names objects.jl. Put the area methods in another file named functions. Create a new file named Geometry.jl. Create a module inside it with the same name. Inside the module, include the two files. You may export the function and objects. Test your module.
include("d1Geometry.jl")
using .Geometry

circle = Circle(Point(12,43),3)
area(circle)
square = Square(4)
area(square)

#8)Use the following dataset, take a subset of it where the values of the first column are less than the mean of the first column, then write it to file.
using RDatasets
using Statistics
using CSV
df = dataset("datasets","anscombe")
meanCol1 = mean(df[:,1])
cutdf = df[df.X1 .< meanCol1, :]
f = open("d1cutDF.csv","w") do f
    CSV.write(f,cutdf)
end

#9)Read the file you just wrote into a DataFrame. check whether it is the same as the one you wrote.

f = open("d1cutDF.csv")
    fromfile = CSV.read(f)
close(f)

cutdf == fromfile

#10)The dataset below is has the results of a national survey in Chile. Column education is a categorical column. For each education category, create a new column in the dataset where the values are either 0 or 1, 1 pointing to that admission category. Then remove the education column. This process is called “one hot encoding” and as we will see is a central process in machine learning.
using RDatasets
using DataFrames
df = dataset("car","Chile")
#=
function onehotcolumn(dfin::DataFrame, colnam::String)
    df = deepcopy(dfin)
    #find column number
    nam = names(df)
    colnum = 0
    for i in 1:length(nam)
        if colnam == nam[i]
            colnum = i
            break
        end
    end
    if colnum == 0
        error("Column name not found!")
    end  
    c = deepcopy(df[:,colnum])
    #avoid missing values in column to be split
    for i in 1:length(c)
        if c[i] === missing
           c[i] = "missing" 
        end
    end  
    cats = unique(c)
    for catenr in 1:length(cats)
        arr = []
        catena = cats[catenr]
        for i in c
            if i == catena
                push!(arr, 1)
            else
                push!(arr, 0)
            end
        end
        df.temp = arr
        push!(nam, colnam*catena)
        rename!(df, nam)
    end
    select!(df, Not(colnam))
    return(df)
end
=#
#I moved this function into a separate file (and added a bit more funtionality) since it is apparently used regularly.
include("ML.jl")
using .ML
onehotencode(df,"Education")

#11)Create scatter and line plots with the dataset above. Give appropriate axis labels to the plots
using Plots
sort!(df, :Age)
x = df.Age
y = df.Income
plot(x,y, xlabel = "Age", ylabel = "Income", title = "Income vs Age", seriestype = :scatter)
#this data is weird.. and the other data in this dataframe is similarly weird.. I think its not only manufactured, but they didn't even do a good job. way too uniform distributions of values.
plot(x,y, xlabel = "Age", ylabel = "Income", title = "Income vs Age")
