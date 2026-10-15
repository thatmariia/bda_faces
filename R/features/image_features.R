
#' Construct features for a single image.
#'
#' @param x Pixel matrix with one image per row.
#' @return Feature vector for the image; currently the original pixels.
image_features <- function(
    x,
    threshold = 0.0625
) {
    img <- as_matrix(x)
    rois <- select_rois(img, facial_rois)

    edges <- image_edges(img)
    edges_rois <- lapply(edges, function(edge) select_rois(edge, facial_rois))

    # features
    c(
        # frey & slate - full image
        unlist(lapply(edges, function(edge) {
            FreySlateFeatures(edge < threshold)
        }), use.names = TRUE),

        # frey & slate - rois
        unlist(lapply(edges_rois, function(edge_rois) {
            unlist(lapply(edge_rois, function(edge_roi) {
                FreySlateFeatures(edge_roi < threshold)
            }), use.names = TRUE)
        }), use.names = TRUE)

    )
}
