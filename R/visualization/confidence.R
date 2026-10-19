#' Plot mean cross-validation performance with approximate confidence intervals.
#' @param models Named list of fitted caret models evaluated on the same folds.
#' @param conf_level Confidence level for the fold-based t intervals.
#' @param metric One or more metric names recorded during cross-validation.
#' @return A ggplot of mean scores and confidence intervals for each model.
plot_confidence_intervals <- function(models, conf_level = 0.95, metric = "Accuracy") {
  resampling <- caret::resamples(models)
  ggplot(resampling, metric = metric, conf.level = conf_level) +
    labs(x = NULL, y = "Cross-validation score")
}
