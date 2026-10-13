#' Read in the images as pixel values (discarding color channels).
#'
#' @param files Ordered PNG file paths.
#' @param split Path component to remove: "train" or "test".
#' @return Matrix with one image per row and one pixel per column.
read_pixels <- function(files, split) {
  pixels <- sapply(files, function(file) c(png::readPNG(file)[, , 1])) |> t()
  # Change row and column names of X to something more manageable
  # (caret::train requires column names)
  rownames(pixels) <- sub(paste0(".+", split, "/"), "", rownames(pixels))
  # Assign column names for X and X_test
  colnames(pixels) <- paste0("p", seq_len(ncol(pixels)))
  pixels
}

#' Process test images in the same way as the training images.
#'
#' @param image_files Lists returned by find_image_files().
#' @return List containing x_train, y, and x_test in matching image order.
prepare_pixels <- function(image_files) {
  # Combine all filenames into a single vector
  train_files <- unlist(image_files$train, use.names = FALSE)
  # Create labels for the training images
  y <- rep(names(image_files$train), lengths(image_files$train))
  list(
    x_train = read_pixels(train_files, "train"), y = y,
    x_test = read_pixels(image_files$test, "test")
  )
}
