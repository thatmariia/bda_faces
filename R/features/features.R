#' Construct features from pixel intensities.
#'
#' @param x Pixel matrix with one image per row.
#' @return Feature matrix in the same image order; currently the original pixels.
features <- function(x) {
  rows <- parallel::mclapply(
    seq_len(nrow(x)),
    function(i) image_features(x[i, ]),
    mc.cores = n_cores
  )
  fs <- do.call(rbind, rows)
  rownames(fs) <- rownames(x)
  fs
}
