#' Construct features from pixel intensities.
#'
#' @param x Pixel matrix with one image per row.
#' @return Feature matrix in the same image order; currently the original pixels.
features <- function(x) {
  rows <- lapply(seq_len(nrow(x)), function(i) image_features(x[i, ]))
  fs <- do.call(rbind, rows)
  row.names(fs) <- row.names(x)
  fs
}
