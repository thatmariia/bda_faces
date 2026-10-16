#' Fit a random forest
#' @param x Training feature matrix.
#' @param y Training class labels aligned with x.
#' @param control Resampling settings from caret::trainControl().
#' @param trees Number of trees in the forest.
#' @return Fitted caret random forest.
fit_random_forest <- function(x, y, control, trees = 500) {
  caret::train(
    x = x, y = y, method = "ranger", trControl = control,
    tuneGrid = data.frame(
      mtry = floor(sqrt(ncol(x))), splitrule = "gini", min.node.size = 10
    ),
    num.trees = trees,
    num.threads = 1,
    importance = "impurity"
  )
}
