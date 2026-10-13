# Check by default; use --fix to apply formatting before linting.
args <- commandArgs(trailingOnly = TRUE)
fix <- identical(args, "--fix")
if (length(args) && !fix) {
  stop("Usage: Rscript check_style.R [--fix]", call. = FALSE)
}
files <- c(
  list.files(
    c("R", "scripts", "analysis"),
    pattern = "\\.(R|Rmd)$", full.names = TRUE, recursive = TRUE
  ),
  list.files(pattern = "\\.(R|Rmd)$")
)
styler::cache_deactivate()
style <- styler::style_file(files, dry = if (fix) "off" else "on")
lint_count <- 0L
for (file in files) {
  lints <- lintr::lint(file, cache = FALSE)
  if (length(lints)) print(lints)
  lint_count <- lint_count + length(lints)
}
if (anyNA(style$changed) || (!fix && any(style$changed)) || lint_count > 0L) {
  stop("Run Rscript check_style.R --fix, then resolve remaining lints.", call. = FALSE)
}
message("Lint and style checks passed.")
