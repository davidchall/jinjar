encode <- function(...) {
  data <- rlang::dots_list(
    ...,
    .named = TRUE,
    .homonyms = "error",
    .check_assign = TRUE
  )

  jsonlite::toJSON(
    data,
    auto_unbox = TRUE, # scalars are not vectors
    no_dots = TRUE # dots reserved by template syntax
  )
}
