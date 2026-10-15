
#' Construct features for a single image.
#'
#' @param x Pixel matrix with one image per row.
#' @return Feature vector for the image; currently the original pixels.
image_features <- function(
    x,
    threshold = 0.0625
) {
    img <- as_matrix(x)

    edges <- image_edges(img)

    # features
    c(
        # frey & slate features
        unlist(lapply(edges, function(edge) {
            FreySlateFeatures(edge < threshold)
        }), use.names = TRUE)
    )
}
