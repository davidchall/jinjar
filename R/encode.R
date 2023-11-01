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

  for (name in names(data)) {
    x <- data[[name]]
    if (!(is_null(x) || is_logical(x) || is_integer(x) || is_double(x) || is_character(x)
          || is_bare_list(x) || inherits_any(x, "data.frame"))) {
      cli::cli_abort(c(
        "Data variable {.arg {name}} is unsupported.",
        "x" = "{.arg {name}} is {.obj_type_friendly {x}}.",
        "i" = "Choices: NULL, logical, integer, double, character, list, dataframe."
      ))
    }
  }

  jsonlite::toJSON(
    data,
    auto_unbox = TRUE, # length-1 vectors output as scalars
    no_dots = TRUE # dots reserved by template syntax
  )
}
