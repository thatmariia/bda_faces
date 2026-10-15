#' Prepare image representations and their ROI crops.
#' @param img Image intensity matrix.
#' @param rois ROI table; regions must fit inside the image's interior and be at least 9 by 9.
#' @return List with named regions, each containing img, edges, gradients, and gabor.
image_variants <- function(img, rois = facial_rois) {
  images <- c(list(full = img), select_rois(img, rois))
  edges <- lapply(image_edges(img), function(edge) {
    c(list(full = edge), select_rois(edge, rois))
  })

  gradient_rois <- rois
  coordinates <- c("x_start", "x_end", "y_start", "y_end")
  gradient_rois[coordinates] <- gradient_rois[coordinates] - 1L
  gradient_maps <- lapply(gradients(img), function(map) {
    c(list(full = map), select_rois(map, gradient_rois))
  })

  gabor_rois <- rois
  gabor_rois[c("x_end", "y_end")] <- gabor_rois[c("x_end", "y_end")] - 8L
  gabor_maps <- lapply(gabor_response(img), function(map) {
    c(list(full = map), select_rois(map, gabor_rois))
  })

  regions <- lapply(names(images), function(name) {
    list(
      img = images[[name]],
      edges = lapply(edges, \(edge) edge[[name]]),
      gradients = lapply(gradient_maps, \(map) map[[name]]),
      gabor = lapply(gabor_maps, \(map) map[[name]])
    )
  })

  list(regions = setNames(regions, names(images)))
}
