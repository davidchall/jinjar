encode <- function(data) {
  jsonlite::toJSON(
    data,
    auto_unbox = TRUE, # scalars are not vectors
    no_dots = TRUE # dots reserved by template syntax
  )
}
