#' Compute features proposed in Frey & Slate (1991).
#'
#' Letter Recognition Using Holland-Style Adaptive Classifiers.
#' Machine Learning, 6, 161.
#' @param X 0/1 or TRUE/FALSE matrix of a letter rasterization.
#' @return Vector with values of all 16 Frey & Slate features.
# nolint start: object_name_linter.
FreySlateFeatures <- function(X) {
  stopifnot(
    is.matrix(X), nrow(X) > 2, ncol(X) > 2,
    is.logical(X) || is.numeric(X), all(!is.na(X))
  )

  mm <- X > 0
  x.edge <- t(diff(t(mm)) > 0)
  y.edge <- diff(mm) < 0

  xy <- which(mm, TRUE)
  d <- dim(mm)[1]

  x.box <- min(xy[, 1]) + (min(xy[, 1]) + max(xy[, 1])) / 2
  y.box <- min(xy[, 2]) + (min(xy[, 2]) + max(xy[, 2])) / 2
  width <- max(xy[, 1]) - min(xy[, 1])
  high <- max(xy[, 2]) - min(xy[, 2])
  onpix <- nrow(xy)
  dx <- (xy[, 1] - x.box) / width^0.5
  dy <- (xy[, 2] - y.box) / high^0.5
  x.bar <- (width / 2 + mean(dx)) / d
  y.bar <- (high / 2 + mean(dy)) / d
  x2bar <- (width^2 / 4 + mean(dx^2)) / d^2
  y2bar <- (high^2 / 4 + mean(dy^2)) / d^2
  xybar <- (width * high / 4 + mean(dx * dy)) / d^2
  x2ybar <- (width^2 * high / 8 + mean(dx^2 * dy)) / d^3
  xy2bar <- (width * high^2 / 8 + mean(dx * dy^2)) / d^3
  x.ege <- mean(Filter(function(x) x > 0, rowSums(x.edge))) / 3
  xegvy <- sum(which(x.edge, TRUE)[, 2]) / d^2
  y.ege <- mean(Filter(function(x) x > 0, colSums(y.edge))) / 3
  yegvx <- sum(which(y.edge, TRUE)[, 1]) / d^2

  x2 <- c(
    x.box = x.box / d, y.box = y.box / d, width = width / d, high = high / d, onpix = onpix / d^2,
    x.bar = x.bar, y.bar = y.bar, x2bar = x2bar, y2bar = y2bar, xybar = xybar,
    x2ybar = x2ybar, xy2bar = xy2bar, x.ege = x.ege, xegvy = xegvy, y.ege = y.ege,
    yegvx = yegvx
  ) * 15
  x2
}
# nolint end: object_name_linter.
