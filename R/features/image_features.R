#' Construct features for a single image.
#'
#' @param x Vector of pixel intensities for one image.
#' @param edge_threshold Threshold for binary edge features.
#' @return Numeric vector named by feature family, region, and measurement.
image_features <- function(x, edge_threshold = 0.0625) {
  v <- image_variants(as_matrix(x))
  regions <- v$regions
  cutoff <- unname(quantile(regions$full$img, 0.3))

  # Select the regions and settings for each feature family here.
  groups <- list(
    hog = all_hog_features(regions),
    gabor = lapply(regions[c("mouth_wide", "brows", "nose_wide")], gabor_features),
    frey_slate = lapply(regions, frey_slate_features, threshold = edge_threshold),
    appearance = lapply(
      regions[c("full", "mouth", "nose")], appearance_features,
      cutoff = cutoff
    ),
    pixel_summary = list(full = pixel_summary_features(regions$full)),
    facial_bands = facial_band_features(regions$full, threshold = edge_threshold),
    gradient = lapply(
      regions[c("full", "mouth", "nose")], gradient_features
    ),
    projection = lapply(regions[c("mouth", "nose")], projection_features),
    contrast = lapply(regions[c("mouth", "nose")], contrast_features),
    symmetry = lapply(regions[c("mouth", "nose")], symmetry_features),
    relationships = relationship_features(regions),
    entropy = list(full = entropy_features(regions$full))
  )

  unlist(groups, use.names = TRUE)
}
