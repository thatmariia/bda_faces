#' Convert a vector to a matrix.
#'
#' @param x Vector to convert.
#' @param nrow Number of rows in the resulting matrix.
#' @param ncol Number of columns in the resulting matrix.
#' @param byrow Whether to fill the matrix by rows.
#' @return Matrix with the specified dimensions.
as_matrix <- function(
  x,
  nrow = sqrt(length(x)),
  ncol = sqrt(length(x)),
  byrow = FALSE
) {
  matrix(x, nrow = nrow, ncol = ncol, byrow = byrow)
}
