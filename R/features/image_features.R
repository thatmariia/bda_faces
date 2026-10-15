#' Apply a function to prepared variants and their regions.
#' @param f Function returning numeric measurements.
#' @param v Named list of variants, each containing img and ROI matrices.
#' @param regions Whether to include ROI crops.
#' @return Named numeric feature vector.
apply_to_all <- function(f, v, regions = TRUE) {
  unlist(lapply(v, function(variant) {
    if (!regions) {
      variant <- variant["img"]
    }

    lapply(variant, f)
  }), use.names = TRUE)
}

#' Construct features for a single image.
#'
#' @param x Pixel matrix with one image per row.
#' @param edge_threshold Threshold for edge detection.
#' @return Feature vector for the image; currently the original pixels.
image_features <- function(
    x,
    edge_threshold = 0.0625
) {
    img <- as_matrix(x)
    v <- image_variants(img, facial_rois)

    # features
    c(
    hog = unlist(
        Map(hog, v$gradients$mag, v$gradients$theta),
        use.names = TRUE
    ),

    frey_slate = apply_to_all(
        function(r) FreySlateFeatures(r < edge_threshold),
        v$edges
    ),

    dark_share = apply_to_all(
        function(r) dark_share(img, r),
        v
    )
  )
}
