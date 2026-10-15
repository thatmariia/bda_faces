#' Train the configured models using the same data and resampling settings.
#'
#' @param x Training feature matrix.
#' @param y Training class labels aligned with x.
#' @param control Resampling settings from caret::trainControl().
#' @param seed Seed reset before each fit for repeatability.
#' @return List with named model fits in models and elapsed seconds in timings.
train_models <- function(x, y, control, seed = 2023) {
  trainers <- list(
    tree = fit_classification_tree,
    pca_tree = fit_pca_classification_tree,
    forest = fit_random_forest
  )
  models <- list()
  timings <- numeric()
  for (name in names(trainers)) {
    cat("Training model:", name, "\n")
    flush.console()
    set.seed(seed)
    tt <- Sys.time() # Measure execution time
    models[[name]] <- trainers[[name]](x, y, control)
    timings[name] <- as.numeric(difftime(Sys.time(), tt, units = "secs"))
  }
  list(
    models = models,
    timings = tibble::tibble(model = names(timings), seconds = unname(timings))
  )
}
