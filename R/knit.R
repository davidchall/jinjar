#' knit engine
#'
#' You can include templates and their rendered output in an RMarkdown document.
#' This is achieved using the `jinjar` RMarkdown engine, which reads chunk options:
#'
#' * `data`: A named list of variables to pass to the template.
#' * `engine.opts`: A named list of engine options:
#'   * `lang`: A string (e.g. `"sql"`, `"html"`) to specify the syntax
#'   highlighting applied to the template and its rendered output.
#'   * `config`: An engine configuration object (see [jinjar_config()]).
#' @noRd
knit_jinjar <- function(options) {
  engine_output <- get("engine_output", envir = asNamespace("knitr"))

  if (identical(.Platform$GUI, "RStudio") && is.character(options$data)) {
    options$data <- get(options$data, envir = globalenv())
  }

  code <- paste(options$code, collapse = "\n")
  out <- if (options$eval) {
    config <- options$engine.opts$config %||% default_config()
    render(code, !!!options$data, .config = config)
  } else ""

  # override styling and syntax highlighting
  lang <- options$engine.opts$lang
  options$class.source <- c(options$class.source, lang, "bg-info")
  options$class.output <- c(options$class.output, lang, "bg-success")
  options$comment <- NULL

  engine_output(options, code, out)
}
