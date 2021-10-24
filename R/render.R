#' Render template
#'
#' Data is passed to a template to render the final document.
#'
#' @param .x The template. Choices:
#' * A template string.
#' * A path to a template file (use [fs::path()]).
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Data passed to the template.
#' @param .config The engine configuration. The default matches Jinja defaults,
#'   but you can use [jinjar_config()] to customize things like syntax delimiters,
#'   whitespace control, and loading auxiliary templates.
#' @return String containing rendered template.
#'
#' @seealso `vignette("template-syntax")` describes how to write templates and
#'   render them using data variables.
#' @examples
#' # pass data as arguments
#' render("Hello {{ name }}!", name = "world")
#'
#' # pass data as list
#' params <- list(name = "world")
#' render("Hello {{ name }}!", !!!params)
#'
#' # render template file
#' \dontrun{
#' render(fs::path("template.txt"), name = "world")
#' }
#' @export
render <- function(.x, ...) {
  UseMethod("render")
}

#' @rdname render
#' @export
render.character <- function(.x, ..., .config = default_config()) {
  checkmate::assert_string(.x, min.chars = 1)
  checkmate::assert_class(.config, "jinjar_config")

  c_render(.x, encode(...), .config)
}

#' @rdname render
#' @export
render.fs_path <- function(.x, ..., .config = default_config()) {
  checkmate::assert_string(.x, min.chars = 1)
  checkmate::assert_class(.config, "jinjar_config")

  if (inherits(.config$loader, "path_loader")) {
    if (!fs::path_has_parent(.x, .config$loader$path)) {
      .x <- fs::path_abs(.x, .config$loader$path)
    }
  }

  checkmate::assert_file_exists(.x, access = "r")

  c_render(read_utf8(.x), encode(...), .config)
}

read_utf8 <- function(path) {
  paste(readLines(path, encoding = "UTF-8", warn = FALSE), collapse = "\n")
}
