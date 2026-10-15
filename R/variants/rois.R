
#' Regions of interest (ROIs) for facial features.
#' LLM src=https://chatgpt.com/share/6ad01c8d-bb80-83eb-b321-eb2cff57060d
facial_rois <- tibble(
  region = c(
    "left_eyebrow",
    "right_eyebrow",
    "left_eye",
    "right_eye",
    "glabella",
    "nose",
    "mouth",
    "left_cheek",
    "right_cheek"
  ),
  x_start = c(5,  26, 5,  26, 20, 16, 8,  3,  33),
  x_end   = c(22, 43, 22, 43, 28, 32, 40, 15, 45),
  y_start = c(10, 10, 16, 16, 12, 20, 32, 24, 24),
  y_end   = c(18, 18, 26, 26, 22, 34, 46, 36, 36)
)

#' Select rois from an image.
#'
#' @param img Pixel matrix of the image.
#' @param rois The regions of interest to select; a tibble with columns `x_start`, `x_end`, `y_start`, and `y_end`.
#' @return Pixel matrices of the ROI.
select_rois <- function(img, rois) {
    regions <- lapply(seq_len(nrow(rois)), function(i) {
        roi <- rois[i, ]
        img[roi$y_start:roi$y_end, roi$x_start:roi$x_end, drop = FALSE]
    })

    setNames(regions, rois$region)
}
