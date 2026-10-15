
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
  x = c(5, 26, 5, 26, 20, 16, 8, 3, 33),
  y = c(10, 10, 16, 16, 12, 20, 32, 24, 24),
  width = c(17, 17, 17, 17, 8, 16, 32, 12, 12),
  height = c(8, 8, 10, 10, 10, 14, 14, 12, 12)
)
