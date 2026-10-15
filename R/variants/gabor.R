#' Compute Gabor filter responses for an image.
#' LLM src=https://chatgpt.com/share/6ad063b8-dc08-83ed-a9ff-6aa52d1a7d97
#' @param img Pixel matrix of the image, at least 9 by 9 pixels.
#' @param wavelengths Vector of wavelengths for the Gabor filters.
#' @param sigma Standard deviation of the Gaussian envelope, scalar or per wavelength.
#' @param gamma Aspect ratio of the Gaussian envelope.
#' @return Named list of valid 9 by 9 filter responses, with 8 fewer rows and columns.
gabor_response <- function(
  img,
  wavelengths = c(4, 7),
  sigma = 2,
  gamma = 0.5
) {
  stopifnot(is.matrix(img), nrow(img) >= 9L, ncol(img) >= 9L)
  nr <- nrow(img)
  nc <- ncol(img)
  orientations <- c(0, pi / 4, pi / 2, 3 * pi / 4)
  sigma <- rep_len(sigma, length(wavelengths))

  out <- vector("list", length(wavelengths) * length(orientations))
  names(out) <- as.vector(t(outer(
    paste0("lambda", wavelengths),
    c("0", "45", "90", "135"),
    paste,
    sep = "_"
  )))

  # Matrix rows are y coordinates; columns are x coordinates.
  coords <- -4:4
  xy <- expand.grid(y = coords, x = coords)
  x <- xy$x
  y <- xy$y

  k <- 0L

  for (a in seq_along(wavelengths)) {
    lambda <- wavelengths[a]
    s <- sigma[a]

    for (theta in orientations) {
      k <- k + 1L

      xr <- x * cos(theta) + y * sin(theta)
      yr <- -x * sin(theta) + y * cos(theta)

      kernel <- exp(-(xr^2 + gamma^2 * yr^2) / (2 * s^2)) *
        cos(2 * pi * xr / lambda)

      kernel <- kernel - mean(kernel)
      kernel <- kernel / sqrt(sum(kernel^2))

      kernel <- matrix(kernel, length(coords), length(coords))

      h <- nr - 8L
      w <- nc - 8L
      response <- matrix(0, h, w)

      # Valid convolution region: no padding or output rescaling.
      for (j in seq_len(ncol(kernel))) {
        for (i in seq_len(nrow(kernel))) {
          response <- response +
            kernel[i, j] * img[i:(i + h - 1L), j:(j + w - 1L), drop = FALSE]
        }
      }

      out[[k]] <- response
    }
  }

  out
}
