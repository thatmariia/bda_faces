#' Fit a CART using 5-fold cross-validation to tune the complexity parameter.
#'
#' @param x Training feature matrix.
#' @param y Training class labels aligned with x.
#' @param control Resampling settings from caret::trainControl().
#' @param cp Complexity parameter.
#' @return Fitted caret classification tree.
fit_classification_tree <- function(x, y, control, cp = 0.02) {
  caret::train(
    x = x, y = y, method = "rpart", trControl = control,
    tuneGrid = data.frame(cp = cp)
  )
}
