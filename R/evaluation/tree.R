#' Graphical visualization of the decision tree.
#'
#' @param model Fitted caret classification tree.
#' @return Invisibly returns NULL; draws the tree on the current device.
plot_tree <- function(model) {
  plot(model$finalModel, compress = TRUE, uniform = TRUE, margin = 0.05, branch = 0.75)
  text(model$finalModel, cex = 0.8, all = TRUE, use.n = TRUE)
  invisible(NULL)
}
