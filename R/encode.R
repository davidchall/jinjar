encode <- function(...) {
  data <- dots_list(..., .homonyms = "error", .check_assign = TRUE)

  if (!is_named(data)) {
    vars <- enexprs(...)
    unnamed <- paste0("`", vars[!have_name(vars)], "`", collapse = ", ")

    abort(c(
      "All data variables must be named.",
      "x" = sprintf("We found unnamed variables: %s", unnamed)
    ))
  }

  jsonlite::toJSON(
    data,
    auto_unbox = TRUE, # length-1 vectors output as scalars
    no_dots = TRUE # dots reserved by template syntax
  )
}
