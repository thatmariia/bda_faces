#' Compute whole-image pixel-intensity entropy.
#' @param region Prepared region containing pixel intensities in [0, 1] in img.
#' @param bins Number of equal-width brightness bins.
#' @return Shannon entropy using natural logarithms.
entropy_features <- function(region, bins = 32L) {
  counts <- hist(
    c(region$img),
    breaks = seq(0, 1, length.out = bins + 1L), plot = FALSE
  )$counts
  p <- counts / sum(counts)
  -sum(p[p > 0] * log(p[p > 0]))
}
