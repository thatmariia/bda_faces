#' Compute edges by differencing neighboring pixels.
#'
#' @param im Image intensity matrix.
#' @return List of horizontal, vertical, and diagonal differences.
image_edges <- function(im) {
  h_edge <- im[-1, ] - im[-nrow(im), ] # horizontal
  v_edge <- im[, -1] - im[, -ncol(im)] # vertical
  d_edge <- h_edge[, -1] - h_edge[, -ncol(im)] # diagonal
  list(horizontal = h_edge, vertical = v_edge, diagonal = d_edge)
}
