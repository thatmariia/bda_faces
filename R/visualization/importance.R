#' Plot feature importance for a model.
#' @param model Fitted caret model with variable importance.
#' @param top Number of top features to display in the plot.
#' @return A plot of feature importance.
plot_feature_importance <- function(model, top = 30) {
  importance <- caret::varImp(model)
  plot(importance, top = top)
}