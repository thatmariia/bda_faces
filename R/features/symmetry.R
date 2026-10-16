#' Compare a region with its horizontal reflection.
#' @param region Prepared region containing an intensity matrix in img.
#' @return Named numeric value measuring left-right asymmetry.
symmetry_features <- function(region) {
  img <- region$img
  c(horizontal = mean(abs(img - img[, rev(seq_len(ncol(img))), drop = FALSE])))
}
