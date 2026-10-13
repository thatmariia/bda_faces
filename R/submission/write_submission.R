#' Write to file.
#'
#' @param predictions Predicted classes in test-image order.
#' @param files Test image filenames in prediction order.
#' @param path Destination CSV path.
#' @return Submission tibble, also written to path.
write_submission <- function(predictions, files, path) {
  submission <- tibble::tibble(file = files, category = predictions)
  submission |> readr::write_csv(file = path)
  submission
}
