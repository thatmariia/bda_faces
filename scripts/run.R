source("scripts/report.R")
sections <- read_sections()
args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 1L) stop("Usage: Rscript scripts/run.R [section-name]")
if (length(args)) {
  last <- match(args, tools::file_path_sans_ext(basename(sections)))
  if (is.na(last)) stop("Unknown section: ", args)
  sections <- sections[seq_len(last)]
}
source("scripts/setup.R")
run_sections(sections)
