#' knit engine
#'
#' You can include templates and their rendered output in an RMarkdown document.
#' This is achieved using the `jinjar` RMarkdown engine, which reads chunk options:
#'
#' * `data`: A named list of variables to pass to the template.
#' * `jinjar_lang`: A string (e.g. `"sql"`, `"html"`) to choose the syntax
#'   highlighting applied to the template and its rendered output.
#' * `jinjar_config`: A `"jinjar_config"` object to configure the template engine.
#' @noRd
knit_jinjar <- function(options) {
  engine_output <- get("engine_output", envir = asNamespace("knitr"))

  if (identical(.Platform$GUI, "RStudio") && is.character(options$data)) {
    options$data <- get(options$data, envir = globalenv())
  }
  if (identical(.Platform$GUI, "RStudio") && is.character(options$jinja_config)) {
    options$jinja_config <- get(options$jinja_config, envir = globalenv())
  }

  code <- paste(options$code, collapse = "\n")
  jinjar_config <- options$jinjar_config %||% default_config()
  out <- render(code, !!!options$data, .config = jinjar_config)

  # override styling and syntax highlighting
  options$class.source <- c(options$class.source, options$jinjar_lang, "bg-info")
  options$class.output <- c(options$class.output, options$jinjar_lang, "bg-success")
  options$comment <- NULL

  engine_output(options, code, out)
}
