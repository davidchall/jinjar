#' Render template
#'
#' Data is passed to a template to render the final document.
#'
#' @param template A string
#' @param data A named list passed to template.
#' @export
render <- function(template, data) {
  if (!is.character(template) || length(template) != 1) {
    stop("`template` must be a string.")
  }

  c_render(template, encode(data))
}
