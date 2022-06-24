#' Parse template
#'
#' Sometimes you want to render multiple copies of a template, using different
#' sets of data variables. [parse_template()] returns an intermediate version
#' of the template, so you can [render()] repeatedly without re-parsing the
#' template syntax.
#'
#' @param .x The template. Choices:
#' * A template string.
#' * A path to a template file (use [fs::path()]).
#' @inheritParams render
#' @return A `"jinjar_template"` object.
#'
#' @seealso
#' * [render()] to render the final document using data variables.
#' * `vignette("template-syntax")` describes how to write templates.
#' @examples
#' x <- parse_template("Hello {{ name }}!")
#' render(x, name = "world")
#' @name parse
#' @export
parse_template <- function(.x, .config) {
  UseMethod("parse_template")
}

#' @rdname parse
#' @export
parse_template.character <- function(.x, .config = default_config()) {
  check_string(.x)
  if (!inherits(.config, "jinjar_config")) {
    cli::cli_abort("{.arg .config} must be a {.cls jinjar_config} object.")
  }

  structure(
    .x,
    config = .config,
    parsed = parse_(.x, .config),
    class = "jinjar_template"
  )
}

#' @rdname parse
#' @export
parse_template.fs_path <- function(.x, .config = default_config()) {
  read_utf8 <- function(path) {
    paste(readLines(path, encoding = "UTF-8", warn = FALSE), collapse = "\n")
  }

  if (inherits(.config$loader, "path_loader")) {
    if (!fs::path_has_parent(.x, .config$loader$path)) {
      .x <- fs::path_abs(.x, .config$loader$path)
    }
  }

  check_file_exists(.x)

  parse_template(read_utf8(.x), .config)
}

#' @export
print.jinjar_template <- function(x, ...) {
  cat(x)

  invisible(x)
}
