#' Prepare image representations and their ROI crops.
#' @param img Image intensity matrix.
#' @param rois ROI table; regions must fit inside the image's interior.
#' @return Lists of intensity, edge, and gradient maps by region.
image_variants <- function(img, rois = facial_rois) {
    gradient_rois <- rois
    coordinates <- c("x_start", "x_end", "y_start", "y_end")
    gradient_rois[coordinates] <- gradient_rois[coordinates] - 1L

    list(
        regions = c(
            list(img = img),
            select_rois(img, rois)
        ),
        edges = lapply(image_edges(img), function(edge) {
            c(
            list(img = edge),
            select_rois(edge, rois)
            )
        }),
        gradients = lapply(gradients(img), function(map) {
            c(
            list(img = map),
            select_rois(map, gradient_rois)
            )
        })
    )
}