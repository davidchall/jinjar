check_string <- function(x, arg = caller_arg(x), call = caller_env()) {
  if (!is_string(x)) {
    cli::cli_abort("{.arg {arg}} must be a string", call = call)
  }
}

check_bool <- function(x, arg = caller_arg(x), call = caller_env()) {
  if (!is_bool(x)) {
    cli::cli_abort("{.arg {arg}} must be TRUE or FALSE", call = call)
  }
}

check_count <- function(x, inf = FALSE, arg = caller_arg(x), call = caller_env()) {
  finite <- if (inf) NULL else TRUE
  if (!is_scalar_integerish(x, finite = finite) || is.na(x) || x <= 0) {
    cli::cli_abort("{.arg {arg}} must be a positive integer", call = call)
  }
}

check_file_exists <- function(x, arg = caller_arg(x), call = caller_env()) {
  if (!fs::file_exists(x) || fs::dir_exists(x)) {
    cli::cli_abort("File does not exist: {.file {x}}", call = call)
  }
}

check_dir_exists <- function(x, arg = caller_arg(x), call = caller_env()) {
  if (!fs::dir_exists(x)) {
    cli::cli_abort("Directory does not exist: {.path {x}}", call = call)
  }
}
