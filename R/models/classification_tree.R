#' Fit a CART.
#'
#' @param x Training feature matrix.
#' @param y Training class labels aligned with x.
#' @param control Resampling settings from caret::trainControl().
#' @param cp Complexity parameters to compare using cross-validation.
#' @param pre_process Optional preprocessing methods passed to caret::train().
#' @return Fitted caret classification tree.
fit_classification_tree <- function(
  x, y, control,
  cp = c(0.001, 0.005, 0.01, 0.02, 0.05),
  pre_process = NULL
) {
  caret::train(
    x = x, y = y, method = "rpart", trControl = control,
    preProcess = pre_process,
    tuneGrid = data.frame(cp = cp)
  )
}
