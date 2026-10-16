#' Compare mouth appearance and regional gradients with the full face.
#' @param regions Prepared regions including full, mouth, nose, and both eyebrows.
#' @return Named numeric vector of regional differences and gradient ratios.
relationship_features <- function(regions) {
  face_gradient <- mean(regions$full$gradients$mag)
  brow_gradients <- c(
    regions$left_eyebrow$gradients$mag,
    regions$right_eyebrow$gradients$mag
  )

  c(
    mouth_face_darkness = mean(regions$full$img) - mean(regions$mouth$img),
    nose_face_gradient = mean(regions$nose$gradients$mag) / (face_gradient + 1e-8),
    brows_face_gradient = mean(brow_gradients) / (face_gradient + 1e-8)
  )
}
