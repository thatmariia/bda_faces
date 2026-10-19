#' Construct features from pixel intensities.
#'
#' @param x Pixel matrix with one image per row.
#' @return Feature matrix in the same image order.
features <- function(x) {
  rows <- parallel::mclapply(
    seq_len(nrow(x)),
    function(i) image_features(x[i, ]),
    mc.cores = n_cores
  )
  fs <- do.call(rbind, rows)
  rownames(fs) <- rownames(x)

  # Combine the handcrafted features with the deep features.
  # Commented out because the deep features are not used in the final model,
  # see Appendix.
  # cbind(fs, deep_features(x))  nolint: commented_code_linter
  fs
}
