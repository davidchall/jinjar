#' Render template
#'
#' Data is passed to a template to render the final document.
#'
#' @param .x The template.
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Data passed to the template.
#' @param .config The engine configuration (see [engine_config()]).
#' @export
render <- function(.x, ..., .config = engine_config()) {
  checkmate::assert_string(.x, min.chars = 1)
  checkmate::assert_class(.config, "rinja_engine_config")

  data <- rlang::dots_list(
    ...,
    .named = TRUE,
    .homonyms = "error",
    .check_assign = TRUE
  )

  c_render(.x, encode(data), .config)
}
