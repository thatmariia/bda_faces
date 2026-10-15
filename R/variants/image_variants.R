#' Prepare image representations and their ROI crops.
#' @param img Image intensity matrix.
#' @param rois ROI table; regions must fit inside the image's interior.
#' @return List with named regions, each containing img, edges, and gradients.
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

  regions <- lapply(names(images), function(name) {
    list(
      img = images[[name]],
      edges = lapply(edges, \(edge) edge[[name]]),
      gradients = lapply(gradient_maps, \(map) map[[name]])
    )
  })

  list(regions = setNames(regions, names(images)))
}
