#' Compute gradients of an image using centered differences.
#' LLM src=https://chatgpt.com/share/6ad03ae8-048c-83ed-8ed3-ff2b32f26812
#' @param img Pixel matrix of the image.
#' @return A list containing gradient matrices `gx`, `gy`, `mag`, and `theta`.
gradients <- function(img) {
  stopifnot(is.matrix(img), nrow(img) >= 3, ncol(img) >= 3)

  nr <- nrow(img)
  nc <- ncol(img)

  rows <- 2:(nr - 1)
  cols <- 2:(nc - 1)

  # Centered differences on interior pixels
  gx <- (img[rows, cols + 1, drop = FALSE] - img[rows, cols - 1, drop = FALSE]) / 2

  gy <- (img[rows + 1, cols, drop = FALSE] - img[rows - 1, cols, drop = FALSE]) / 2

  # Gradient magnitude
  mag <- sqrt(gx^2 + gy^2)

  # Unsigned orientation in [0, pi)
  theta <- atan2(gy, gx) %% pi

  list(gx = gx, gy = gy, mag = mag, theta = theta)
}
