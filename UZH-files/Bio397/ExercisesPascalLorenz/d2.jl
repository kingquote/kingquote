include("ML.jl")
using .ML

#before starting, I converted the xls file to csv by opening it in excel and saving as csv
ds1 = CSV.read("dataset1.csv")
df1 = deepcopy(ds1)
ds2 = CSV.read("dataset2.csv")
df2 = deepcopy(ds2)
ds3 = CSV.read("dataset3.csv")
df3 = deepcopy(ds3)

#missing values:
#I decided that for df1, I would be interested in the adress only so far as the zip code determines. If more exact adress columns had many missing, i removed the column. for the zip code though, i removed rows with missing values, even though more than 30% were lost.
df1 = safedropmissing(df1)
select!(df1, Not(["Candidate Address 2","Office Address 2","City","Office Address 1","Office Phone","Parish","Salutation"]))
dropmissing!(df1, "Zip Code")

df2 = safedropmissing(df2)
select!(df2, Not(["Agency Project ID","Planned Project Completion Date (B2)", "Projected/Actual Project Completion Date (B2)"]))

#date format unification:
function testdateformat(dfin::DataFrame,colname::String)
    for datepos in 1:length(dfin[!,colname])
        if dfin[!,colname][datepos][3] != '/'
            print(string(datepos)*": "*dfin[!,colname][datepos]*"\n")
        end
    end
end

testdateformat(df1,"Expiration Date")
testdateformat(df1,"Commissioned Date")
testdateformat(df2,"Start Date")
testdateformat(df2,"Completion Date (B1)")
testdateformat(df2,"Updated Date")
df2[1,"Updated Date"] = "30/09/2012"

#different representation of the same values
select!(df3, Not("Gender_no"))

#Formulas (e.g. summation)
select!(df2, Not(["Schedule Variance (in days)","Cost Variance (\$ M)","Cost Variance (%)"]))
#in df3, i can see that some of the values depend on each other (like total gross earnings - total expense = total income). However, the only one I would feel comfortable removing would be the income one, yet that is what the standard deviaton column refers to, so I want to keep it.

#Mixed numerical scales
df2 = minmaxnormalize(df2, ["Lifecycle Cost","Schedule Variance (%)","Planned Cost (\$ M)","Projected/Actual Cost (\$ M)"])
df3 = minmaxnormalize(df3, ["Estimated_Population","Effective_Returns","Average_Gross_Earnings_from_Employment_�","Average_Total_Gross_Earnings_�","Average_Total_Expenses_�"])

#I already ckecked for redundant values, and I will not spell check thousands of entries, but i do want to do some one hot encoding on some categories
df1 = onehotencode(df1, ["State","State_1","Ethnicity", "Sex","Party Code"])
df3 = onehotencode(df3, ["GP_Type","Contract_Type","Country","Gender","Average_Gross_Earnings_from_Self_Employment_�","Age_Band"])