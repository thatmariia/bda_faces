#' Summarize Gabor responses for a prepared region.
#' @param region Prepared region containing a named list of response matrices in gabor.
#' @return Named numeric vector of mean absolute responses and standard deviations.
gabor_features <- function(region) {
  unlist(lapply(region$gabor, function(response) {
    c(mean_abs = mean(abs(response)), sd = sd(c(response)))
  }), use.names = TRUE)
}
