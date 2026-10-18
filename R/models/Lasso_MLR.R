#' Fit a lasso-penalized multinomial logistic regression.
#' @param x Training feature matrix.
#' @param y Training class labels aligned with x.
#' @param control Resampling settings from caret::trainControl().
#' @param lambda Penalty strengths to compare using cross-validation.
#' @return Fitted caret glmnet model with training-fold preprocessing.
fit_lasso_multinomial <- function(
  x, y, control,
  lambda = 10^seq(-4, -0.5, length.out = 15)
) {
  caret::train(
    x = x, y = y, method = "glmnet", trControl = control,
    preProcess = c("zv", "center", "scale"),
    tuneGrid = expand.grid(alpha = 1, lambda = lambda),
    family = "multinomial"
  )
}