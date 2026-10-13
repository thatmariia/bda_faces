#' Find report sections in filename order.
#'
#' @param path Directory containing Rmd sections with two-digit prefixes.
#' @return Ordered paths to the numbered Rmd sections.
read_sections <- function(path = "analysis") {
  sections <- sort(list.files(path, pattern = "^[0-9]{2}_.*\\.Rmd$", full.names = TRUE))
  stopifnot(length(sections) > 0L)
  sections
}

#' Run the code included by the selected report sections.
#'
#' @param sections Ordered Rmd paths.
#' @param envir Environment receiving the section results.
#' @return Invisibly returns NULL after executing the sections.
run_sections <- function(sections, envir = parent.frame()) {
  code_file <- tempfile(fileext = ".R")
  on.exit(unlink(code_file))
  for (section in sections) {
    message("Running section: ", tools::file_path_sans_ext(basename(section)))
    knitr::purl(section, output = code_file, documentation = 0L, quiet = TRUE)
    source(code_file, local = envir, print.eval = TRUE)
  }
  invisible(NULL)
}
