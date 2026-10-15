#' Compute Histogram of Oriented Gradients (HOG) features for an image.
#' LLM src=https://chatgpt.com/share/6ad037d4-6794-83ed-b0c8-26a083b764cf
#' @param magnitude Matrix of gradient magnitudes.
#' @param angle Matrix of gradient angles (in radians).
#' @param grid Number of cells per direction, or a vertical-horizontal pair.
#' @param bins Number of orientation bins for the histogram.
#' @return Vector of HOG features for the image.
hog <- function(magnitude, angle, grid = 4, bins = 8) {
  stopifnot(
    is.matrix(magnitude),
    is.matrix(angle),
    identical(dim(magnitude), dim(angle))
  )

  if (length(grid) == 1L) grid <- rep(grid, 2L)

  stopifnot(
    length(grid) == 2L,
    all(is.finite(grid)),
    all(grid >= 1 & grid == as.integer(grid)),
    length(bins) == 1L,
    is.finite(bins),
    bins >= 1 & bins == as.integer(bins),
    all(grid <= dim(magnitude))
  )

  nr <- nrow(magnitude)
  nc <- ncol(magnitude)

  # Integer-based cell grouping (works with grid = 1)
  row_groups <- ((seq_len(nr) - 1L) * grid[1]) %/% nr + 1L
  col_groups <- ((seq_len(nc) - 1L) * grid[2]) %/% nc + 1L

  # Orientation bins
  bin_index <- floor(angle / pi * bins) + 1L

  features <- numeric(prod(grid) * bins)
  names(features) <- character(length(features))

  k <- 1L

  for (r in seq_len(grid[1])) {
    for (c in seq_len(grid[2])) {
      cell_bins <- bin_index[
        row_groups == r, col_groups == c, drop = FALSE
      ]

      cell_mags <- magnitude[
        row_groups == r, col_groups == c, drop = FALSE
      ]

      # Magnitude-weighted histogram
      hist <- vapply(
        seq_len(bins),
        function(b) sum(cell_mags[cell_bins == b]),
        numeric(1)
      )

      # Per-cell L2 normalization; flat cells remain zero
      norm <- sqrt(sum(hist^2))
      if (norm > 0) hist <- hist / norm

      idx <- k:(k + bins - 1L)

      features[idx] <- hist
      names(features)[idx] <- sprintf(
        "r%d_c%d_bin%d", r, c, seq_len(bins)
      )

      k <- k + bins
    }
  }

  features
}

#' Compute HOG measurements from a prepared region.
#' @param region Prepared region containing gradient magnitude and angle maps.
#' @param grid Number of cells per direction, or a row-column pair.
#' @param bins Number of orientation bins.
#' @return Named numeric vector of HOG measurements.
hog_features <- function(region, grid = 4, bins = 8) {
  hog(region$gradients$mag, region$gradients$theta, grid = grid, bins = bins)
}
