#' Check performance on training set.
#'
#' @param predictions Predicted classes.
#' @param observed Observed classes in the same order.
#' @return Confusion matrix and classification statistics from caret.
evaluate_classification <- function(predictions, observed) {
  caret::confusionMatrix(predictions, factor(observed))
}
