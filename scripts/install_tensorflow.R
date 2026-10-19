python <- unname(Sys.which("python3.12"))
if (!nzchar(python)) python <- "3.12"
tensorflow::install_tensorflow(
  version = "2.16.2", extra_packages = "tf-keras==2.16.0",
  envname = here::here(".venv"), python_version = python,
  restart_session = FALSE, new_env = FALSE
)
