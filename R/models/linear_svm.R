#' Fit a linear support vector machine.
#' @param x Training feature matrix.
#' @param y Training class labels aligned with x.
#' @param control Resampling settings from caret::trainControl().
#' @param cost Penalty values to compare using cross-validation.
#' @return Fitted caret SVM with training-fold preprocessing.
fit_linear_svm <- function(x, y, control, cost = 0.25) {
  caret::train(
    x = x, y = y, method = "svmLinear2", trControl = control,
    preProcess = c("zv", "center", "scale"),
    tuneGrid = data.frame(cost = cost),
    scale = FALSE, cachesize = 256
  )
}
