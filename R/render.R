#' Render template
#'
#' Data is passed to a template to render the final document.
#'
#' @param template A string
#' @param data A named list passed to template.
#' @param config The engine configuration (see [engine_config()]).
#' @export
render <- function(template, data, config = engine_config()) {
  checkmate::assert_string(template, min.chars = 1)
  checkmate::assert_class(config, "rinja_engine_config")

  c_render(template, encode(data), config)
}
