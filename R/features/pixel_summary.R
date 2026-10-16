#' Compute whole-image pixel summaries.
#' @param region Prepared region containing an intensity matrix in img.
#' @return Named numeric vector; correlations of constant pixels are zero.
pixel_summary_features <- function(region) {
  img <- region$img

  # Pair adjacent pixels directly, avoiding wrap-around between columns.
  correlations <- suppressWarnings(c(
    ver_lag_cor = cor(
      c(img[-1, , drop = FALSE]),
      c(img[-nrow(img), , drop = FALSE])
    ),
    hor_lag_cor = cor(
      c(img[, -1, drop = FALSE]),
      c(img[, -ncol(img), drop = FALSE])
    )
  ))
  correlations[!is.finite(correlations)] <- 0

  c(
    median = median(img),
    min = min(img),
    max = max(img),
    correlations,
    signal_power = mean(img^2)
  )
}
