#' Compute regional brightness and darkness relative to the full image.
#' @param region Prepared region containing an intensity matrix in img.
#' @param cutoff Dark-pixel threshold calculated from the full image.
#' @return Named numeric vector of intensity and dark-pixel summaries.
appearance_features <- function(region, cutoff) {
  img <- region$img
  dark <- img < cutoff
  mid <- nrow(img) %/% 2L
  percentiles <- quantile(img, c(0.1, 0.9), names = FALSE)

  c(
    mean = mean(img),
    sd = sd(c(img)),
    p10 = percentiles[1],
    p90 = percentiles[2],
    dark_fraction = mean(dark),
    dark_top = mean(dark[1:mid, , drop = FALSE]),
    dark_bottom = mean(dark[(mid + 1L):nrow(img), , drop = FALSE])
  )
}
