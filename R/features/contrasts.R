#' Compare mean intensities between halves of a region.
#' @param region Prepared region containing an intensity matrix in img.
#' @return Named numeric vector of top-bottom and left-right contrasts.
contrast_features <- function(region) {
  img <- region$img
  mid_row <- nrow(img) %/% 2L
  mid_col <- ncol(img) %/% 2L

  c(
    top_bottom = mean(img[1:mid_row, , drop = FALSE]) -
      mean(img[(mid_row + 1L):nrow(img), , drop = FALSE]),
    left_right = mean(img[, 1:mid_col, drop = FALSE]) -
      mean(img[, (mid_col + 1L):ncol(img), drop = FALSE])
  )
}
