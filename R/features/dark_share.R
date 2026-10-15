#' Compute the share p% darkest pixels in the image for a given ROI.
#' @param img Pixel matrix of the image.
#' @param roi Pixel matrix of the ROI.
#' @param p Proportion of darkest pixels to select.
dark_share <- function(img, roi = img, p = 0.3) {
    threshold <- quantile(img, p)
    sum(roi < threshold) / length(roi)
}