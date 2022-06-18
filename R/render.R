#' Render template
#'
#' Data is passed to a template to render the final document.
#'
#' @param .x The template. Choices:
#' * A template string.
#' * A path to a template file (use [fs::path()]).
#' * A parsed template (use [parse_template()]).
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Data passed to the template.
#' @param .config The engine configuration. The default matches Jinja defaults,
#'   but you can use [jinjar_config()] to customize things like syntax delimiters,
#'   whitespace control, and loading auxiliary templates.
#' @return String containing rendered template.
#'
#' @seealso
#' * [parse_template()] supports parsing a template once and rendering multiple
#'   times with different data variables.
#' * `vignette("template-syntax")` describes how to write templates.
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
  render(parse_template(.x, .config), ...)
}

#' @rdname render
#' @export
render.fs_path <- function(.x, ..., .config = default_config()) {
  render(parse_template(.x, .config), ...)
}

#' @rdname render
#' @export
render.jinjar_template <- function(.x, ...) {
  render_(attr(.x, "parsed"), encode(...))
}
