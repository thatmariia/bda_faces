#' Compute darkness profiles across rows and columns of a region.
#' @param region Prepared region containing an intensity matrix in img.
#' @return Named numeric vector of projection maxima, SDs, and row slope.
projection_features <- function(region) {
  rp <- rowMeans(1 - region$img)
  cp <- colMeans(1 - region$img)

  c(
    row_max = max(rp),
    row_sd = sd(rp),
    col_max = max(cp),
    col_sd = sd(cp),
    row_slope = cov(seq_along(rp), rp) / var(seq_along(rp))
  )
}
