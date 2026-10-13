#' Get all image files: file names ending ".png".
#'
#' @param data_dir Directory containing the train and test folders.
#' @return Lists of training paths by category and test paths.
find_image_files <- function(data_dir) {
  folders <- c(anger = "anger", happy = "happy", sad = "sadness", disgust = "disgust")
  train <- lapply(folders, function(folder) {
    list.files(file.path(data_dir, "train", folder), pattern = "png$", full.names = TRUE)
  })
  test <- list.files(file.path(data_dir, "test"), pattern = "png$", full.names = TRUE)
  stopifnot(all(lengths(train) > 0L), length(test) > 0L)
  list(train = train, test = test)
}
