#' Define a utility function for painting images.
#'
#' @param x Image array.
#' @param colors Color channels to retain.
#' @param ... Additional image and raster arguments.
#' @param add Whether to add to the current plot.
#' @param axes Whether to show axes.
#' @return Invisibly returns NULL; paints the image on the current device.
paint_image <- function(x, colors = 1:3, ..., add = FALSE, axes = FALSE) {
  if (!add) {
    opar <- par(mar = rep(0, 4))
    image(array(0, dim(x)[1:2]), ..., col = "transparent", axes = axes)
    par(opar)
  }
  x[, , -colors] <- 0
  usr <- par("usr")
  rasterImage(x, usr[1], usr[3], usr[2], usr[4], ...)
  invisible(NULL)
}

#' Visualization utility function.
#'
#' @param x Pixel vector or matrix.
#' @param nr Number of rows in the original image.
#' @return Invisibly returns NULL; draws a grayscale image.
as_image <- function(x, nr = sqrt(length(x))) {
  opar <- par(mar = rep(0, 4))
  on.exit(par(opar))
  image(t(matrix(x, nr))[, nr:1], col = gray(0:255 / 255), axes = FALSE)
  invisible(NULL)
}
