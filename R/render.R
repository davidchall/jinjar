#' Render template
#'
#' Data is passed to a template to render the final document.
#'
#' @param template A string
#' @param data A named list passed to template.
#' @param config The engine configuration (see [engine_config()]).
#' @export
render <- function(template, data, config = engine_config()) {
  if (!is.character(template) || length(template) != 1) {
    stop("`template` must be a string.")
  }
  if (!is_engine_config(config)) {
    stop("`config` must be an engine config.")
  }

  c_render(template, encode(data), config)
}
