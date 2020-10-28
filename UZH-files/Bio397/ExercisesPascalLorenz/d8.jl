using ScikitLearn
using DataVoyager
using DataFrames
using Plots



@sk_import tree: DecisionTreeClassifier

# Load the data
@sk_import datasets: load_breast_cancer
all_data = load_breast_cancer()
X = all_data["data"];
y = all_data["target"];


# Create a tree
model = DecisionTreeClassifier(min_samples_split=2, random_state=0, min_samples_leaf=1, max_depth=4)
fit!(model, X, y)

model.feature_importances_

# Plot the tree
using PyCall
@sk_import tree: export_graphviz
export_graphviz(model, out_file="mytree", class_names=["Healthy", "Cancerous"], feature_names=all_data["feature_names"], leaves_parallel=true, impurity=false, rounded=true, filled=true, label="root", proportion=true)

# you need to install graphviz for python first.
pyimport("graphviz")
dot_graph = read("mytree", String);
j = graphviz.Source(dot_graph, "mytree", "./", "pdf", "dot")
j.render()



#Some functions
Xdf = hcat(X,y)
Voyager(Xdf)

@sk_import preprocessing: OneHotEncoder
@sk_import preprocessing: PolynomialFeatures
@sk_import preprocessing: RobustScaler
@sk_import metrics: r2_score
@sk_import metrics: precision_score
@sk_import metrics: make_scorer
@sk_import model_selection: GridSearchCV
@sk_import model_selection: KFold
@sk_import model_selection: StratifiedKFold
@sk_import neighbors: KNeighborsClassifier

#usage example:
#scale data first
model = KNeighborsClassifier()
parameters = Dict("n_neighbors" => 1:2:30, "weight" => ("uniform", "distance"))
kf = StratifiedKFold(n_splits=5, shuffle=true)
gridsearch = GridSearchCV(model, parameters, scoring="f1", cv=kf, n_jobs=1)
fit!(gridsearch, X, y)
gridsearch.
bestmodel = gridsearch.best_estimator_
gridsearch.best_params_
gridsearch.best_score_

#making a custom scorer
function specificity_score(ytrue, ypred)
    #define score equation here
    return specificity
end
myscorer = make_scorer(specificity_score, greater_is_better=true)



#I redid old exercises at the bottom of the respective days script


#provided workflow example:

using ScikitLearn
@sk_import neighbors: KNeighborsClassifier
@sk_import model_selection: StratifiedKFold
@sk_import metrics: f1_score
@sk_import datasets: load_breast_cancer
@sk_import model_selection: GridSearchCV
@sk_import preprocessing: PolynomialFeatures
@sk_import preprocessing: RobustScaler
@sk_import model_selection: train_test_split

all_data = load_breast_cancer()
X = all_data["data"];
y = all_data["target"];

X_train, X_test, y_train, y_test = train_test_split(X, y, train_size=0.8)


"""
Add polynomials to features to your data.
"""
function addpolynomials(X; degree=2, interaction_only=false, include_bias=true)
  poly = PolynomialFeatures(degree=degree, interaction_only=interaction_only, include_bias=include_bias)
  fit!(poly, X)
  x2 = transform(poly, X)
  return x2
end

function KNN_classification(X_train, X_test, y_train, y_test; nsplits=5, scoring="f1", n_jobs=1, stratify=nothing)

  # Scale the data first
  rscale = RobustScaler()
  X_train = rscale.fit_transform(X_train)

  # build the model and grid search object
  model = KNeighborsClassifier()
  parameters = Dict("n_neighbors" => 1:2:30, "weights" => ("uniform", "distance"))
  kf = StratifiedKFold(n_splits=nsplits, shuffle=true)
  gridsearch = GridSearchCV(model, parameters, scoring=scoring, cv=kf, n_jobs=n_jobs, verbose=0)

  # train the model
  fit!(gridsearch, X_train, y_train)

  best_estimator = gridsearch.best_estimator_

  return best_estimator, gridsearch, rscale
end

### Use the function
######################

best_estimator, gridsearch, rscale = KNN_classification(X_train, X_test, y_train, y_test)

# Make predictions:

# transform X_test
X_test_transformed = rscale.transform(X_test)

y_pred = predict(best_estimator, X_test_transformed)

# Evaluate the predictions

f1_score(y_test, y_pred)

## learning for model evaluation

@sk_import model_selection: learning_curve  

cv = StratifiedKFold(n_splits=nsplits, shuffle=true)
train_sizes, train_scores, test_scores = learning_curve(best_estimator, X_train, y_train, cv=cv, scoring="accuracy", shuffle=true)

