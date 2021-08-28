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

  data_json <- jsonlite::toJSON(data, auto_unbox = TRUE, na = "string")

  c_render(template, data_json)
}
