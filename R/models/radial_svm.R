#' Fit a radial support vector machine.
#' @param x Training feature matrix.
#' @param y Training class labels aligned with x.
#' @param control Resampling settings from caret::trainControl().
#' @param cost Penalty values to compare using cross-validation.
#' @param gamma Radial kernel coefficients to compare using cross-validation.
#' @return Fitted caret SVM with training-fold preprocessing.
fit_radial_svm <- function(x, y, control, cost = 4, gamma = 0.1 / ncol(x)) {
  # Reuse caret's e1071 adapter with a radial kernel.
  model <- caret::getModelInfo("svmLinear2", regex = FALSE)[[1]]
  model$label <- "Radial Support Vector Machines"
  model$parameters <- rbind(
    model$parameters,
    data.frame(parameter = "gamma", class = "numeric", label = "Gamma")
  )
  model$fit <- function(
    x, y, wts, param, lev, last, classProbs, ... # nolint: object_name_linter.
  ) {
    e1071::svm(
      x = as.matrix(x), y = y, kernel = "radial",
      cost = param$cost, gamma = param$gamma,
      probability = classProbs, ...
    )
  }

  caret::train(
    x = x, y = y, method = model, trControl = control,
    preProcess = c("zv", "center", "scale"),
    tuneGrid = expand.grid(cost = cost, gamma = gamma),
    scale = FALSE, cachesize = 256
  )
}
