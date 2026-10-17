library(tidyverse)
library(png)
library(caret, warn.conflicts = FALSE)
library(ranger)
library(glmnet)
options(width = 100)

# Locate the same ckplus directory locally and in Kaggle's mounted inputs.
on_kaggle <- dir.exists("/kaggle/input")
if (on_kaggle) {
  candidates <- c("/kaggle/input", list.dirs("/kaggle/input", recursive = TRUE))
  candidates <- unique(candidates)
  data_dirs <- candidates[
    dir.exists(file.path(candidates, "train", "anger")) &
      dir.exists(file.path(candidates, "test"))
  ]
  if (length(data_dirs) != 1L) stop("Expected exactly one mounted ckplus dataset.")
  data_dir <- data_dirs[[1]]
} else {
  data_dir <- here::here("data", "ckplus")
}
output_dir <- if (on_kaggle) "/kaggle/working" else here::here("output")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

## Use multiple cores whenever possible
n_cores <- if (.Platform$OS.type == "windows") {
  1
} else if (on_kaggle) {
  parallel::detectCores()
} else {
  max(1, parallel::detectCores() - 1)
}
if (n_cores > 1) doMC::registerDoMC(cores = n_cores) else foreach::registerDoSEQ()
