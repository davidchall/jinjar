encode <- function(...) {
  data <- dots_list(..., .homonyms = "error", .check_assign = TRUE)

  if (!is_named(data)) {
    vars <- enexprs(...)
    unnamed <- vars[!have_name(vars)]

    cli::cli_abort(c(
      "All data variables must be named.",
      "x" = "Unnamed variables: {.var {unnamed}}"
    ))
  }

  jsonlite::toJSON(
    data,
    auto_unbox = TRUE, # length-1 vectors output as scalars
    no_dots = TRUE # dots reserved by template syntax
  )
}
