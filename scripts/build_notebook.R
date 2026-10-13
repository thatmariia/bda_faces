# Assemble a standalone Kaggle notebook without running the analysis.
source("scripts/report.R")
read_sections()
ipynb <- rmarkdown::output_format(
  knitr = rmarkdown::knitr_options(
    opts_chunk = list(eval = FALSE),
    opts_hooks = list(child = function(options) {
      options$eval <- TRUE
      options
    }),
    knit_hooks = list(source = function(x, options) {
      cell <- paste0("```r\n", paste(x, collapse = "\n"), "\n```\n:::\n")
      if (is.null(options$fold)) {
        return(paste0("\n::: {.cell .code}\n", cell))
      }
      paste0(
        "\n*", options$fold, "*\n\n",
        "\n::: {.cell .code tags=\"[\\\"hide-input\\\"]\"}\n", cell
      )
    })
  ),
  pandoc = rmarkdown::pandoc_options(to = "ipynb")
)
dir.create("output", showWarnings = FALSE)
notebook_file <- rmarkdown::render(
  "notebook.Rmd",
  output_format = ipynb, output_dir = "output",
  envir = new.env(parent = globalenv()), quiet = TRUE
)
notebook <- jsonlite::read_json(notebook_file)
notebook$cells <- lapply(notebook$cells, function(cell) {
  if ("hide-input" %in% unlist(cell$metadata$tags)) {
    cell$metadata[["_kg_hide-input"]] <- TRUE
    cell$metadata$jupyter <- list(source_hidden = TRUE)
  }
  cell
})
notebook$metadata$kernelspec <- list(name = "ir", display_name = "R", language = "R")
notebook$metadata$language_info <- list(name = "R")
notebook$metadata$kaggle <- list(
  accelerator = "none", isInternetEnabled = TRUE, language = "r",
  sourceType = "notebook", isGpuEnabled = FALSE,
  dataSources = list(list(sourceType = "competition", sourceId = 165962L))
)
notebook$metadata$course_helper_license <- paste(
  readLines("references/frey_slate.LICENSE"),
  collapse = "\n"
)
jsonlite::write_json(notebook, notebook_file, auto_unbox = TRUE, pretty = TRUE, null = "null")
message("Built ", notebook_file)
