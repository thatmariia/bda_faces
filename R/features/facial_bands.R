#' Compute edge, brightness, and asymmetry features for facial bands.
#' @param region Prepared region containing a 48 by 48 intensity matrix in img.
#' @param threshold Minimum absolute neighboring-pixel difference for an edge.
#' @return Named numeric vector of ten summaries for the eyes, mouth, and face.
facial_band_features <- function(region, threshold = 0.0625) {
  img <- region$img
  stopifnot(identical(dim(img), c(48L, 48L)))

  eyes <- 10:24
  mouth <- 30:44
  h_edge <- abs(img[-1, ] - img[-48, ]) > threshold
  v_edge <- abs(img[, -1] - img[, -48]) > threshold
  difference <- abs(img - img[, 48:1])

  c(
    edge_h_eyes = mean(h_edge[eyes, ], na.rm = TRUE),
    edge_v_eyes = mean(v_edge[eyes, ], na.rm = TRUE),
    edge_h_mouth = mean(h_edge[mouth, ], na.rm = TRUE),
    edge_v_mouth = mean(v_edge[mouth, ], na.rm = TRUE),
    mean_eyes = mean(img[eyes, ], na.rm = TRUE),
    sd_eyes = sd(c(img[eyes, ]), na.rm = TRUE),
    mean_mouth = mean(img[mouth, ], na.rm = TRUE),
    sd_mouth = sd(c(img[mouth, ]), na.rm = TRUE),
    asym_face = mean(difference, na.rm = TRUE),
    asym_mouth = mean(difference[mouth, ], na.rm = TRUE)
  )
}
