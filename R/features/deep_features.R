#' Extract fixed ImageNet DenseNet201 features.
#' @param x Matrix of column-wise 48 by 48 images, with pixel values in [0, 1].
#' @param batch_size Number of images processed together.
#' @return Matrix with one image per row and columns prefixed by deep.
deep_features <- function(x, batch_size = 64L) {
  # Keep TensorFlow threads out of the R session used for parallel model fitting.
  worker <- parallel::makePSOCKcluster(1L)
  on.exit(parallel::stopCluster(worker))

  result <- parallel::clusterCall(worker, function(x, batch_size, libraries) {
    .libPaths(libraries)
    model <- keras::application_densenet201(
      weights = "imagenet", input_shape = c(48L, 48L, 3L),
      include_top = FALSE, pooling = "avg"
    )
    # Repeat grayscale images in three channels; Keras handles prediction batches.
    images <- array(t(x), dim = c(48L, 48L, nrow(x), 3L))
    images <- aperm(images, c(3L, 1L, 2L, 4L))
    images <- keras::densenet_preprocess_input(images * 255)
    predict(model, images, batch_size = batch_size, verbose = 0L)
  }, x, batch_size, .libPaths())[[1]]

  rownames(result) <- rownames(x)
  colnames(result) <- paste0("deep.", seq_len(ncol(result)))

  result
}
