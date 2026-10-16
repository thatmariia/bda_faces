#' Fit a classification tree with training-fold PCA of the HOG features.
#' @param x Training feature matrix with HOG columns prefixed by hog.
#' @param y Training class labels aligned with x.
#' @param control Resampling settings from caret::trainControl().
#' @param components Number of HOG principal components to retain.
#' @return Fitted caret tree with preprocessing saved for future predictions.
fit_pca_classification_tree <- function(x, y, control, components = 15) {
  hog_columns <- colnames(x)[startsWith(colnames(x), "hog.")]
  control$preProcOptions$pcaComp <- components

  fit_classification_tree(
    x, y, control,
    pre_process = list(zv = colnames(x), pca = hog_columns)
  )
}
