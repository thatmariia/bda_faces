#' Compute horizontal and vertical contour strength in a region.
#' @param region Prepared region containing gradients gx, gy, and mag.
#' @return Named numeric vector of horizontal, vertical, and total strength.
gradient_features <- function(region) {
  g <- region$gradients
  c(
    horizontal = mean(abs(g$gy)),
    vertical = mean(abs(g$gx)),
    total = mean(g$mag)
  )
}
