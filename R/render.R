#' Render template
#'
#' Data is passed to a template to render the final document.
#'
#' @param .x The template
#' @param ... Data passed to the template.
#' @param .config The engine configuration (see [engine_config()]).
#' @export
render <- function(.x, ..., .config = engine_config()) {
  checkmate::assert_string(.x, min.chars = 1)
  checkmate::assert_class(.config, "rinja_engine_config")

  c_render(.x, encode(...), .config)
}
