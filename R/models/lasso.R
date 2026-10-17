#' Fit a lasso multinomial logistic regression
#' @param x Training feature matrix.
#' @param y Training class labels aligned with x.
#' @param control Resampling settings from caret::trainControl().
#' @param grid Values of lambda to compare using cross-validation.
#' @return Fitted caret lasso model.
fit_lasso <- function(x, y, control, grid = 10^seq(0, -4, length = 20)) {
  # glmnet() with alpha = 1 fits the lasso; glmnet standardizes the features.
  caret::train(
    x = as.matrix(x), y = y, method = "glmnet", trControl = control,
    tuneGrid = expand.grid(alpha = 1, lambda = grid),
    family = "multinomial"
  )
}