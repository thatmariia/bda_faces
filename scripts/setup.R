library(tidyverse)
library(png)
library(caret, warn.conflicts = FALSE)
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
if (.Platform$OS.type == "unix" && requireNamespace("doMC", quietly = TRUE)) {
  doMC::registerDoMC(cores = 4)
} else {
  foreach::registerDoSEQ()
}
