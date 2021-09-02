#' Configure the templating engine
#'
#' Create an object to configure the templating engine behavior (e.g. customize
#' the syntax). The default values have been chosen to match the Jinja defaults.
#'
#' @note The equivalent Jinja class is `Environment`, but this term has special
#' significance in R (see [environment()]).
#'
#' @param loader How the engine discovers templates. Choices:
#'   * `NULL` (default), disables search for templates.
#'   * Path to template directory
#'   * A [`loader`] object
#' @param block_open,block_close The opening and closing delimiters
#'   for control blocks. Default: \verb{"\{\%"} and \verb{"\%\}"}.
#' @param variable_open,variable_close The opening and closing delimiters
#'   for print statements. Default: `"{{"` and `"}}"`.
#' @param comment_open,comment_close The opening and closing delimiters
#'   for comments. Default: `"{#"` and `"#}"`.
#' @param line_statement The prefix for an inline statement. If `NULL` (the
#'   default), inline statements are disabled.
#' @param trim_blocks Remove first newline after a block. Default: `FALSE`.
#' @param lstrip_blocks Remove inline whitespace before a block. Default: `FALSE`.
#' @return A `"rinja_engine_config"` object.
#'
#' @examples
#' engine_config()
#' @importFrom checkmate qassert
#' @export
engine_config <- function(loader = NULL,
                          block_open = "{%",
                          block_close = "%}",
                          variable_open = "{{",
                          variable_close = "}}",
                          comment_open = "{#",
                          comment_close = "#}",
                          line_statement = NULL,
                          trim_blocks = FALSE,
                          lstrip_blocks = FALSE) {

  checkmate::assert(
    checkmate::check_null(loader),
    checkmate::check_directory_exists(loader),
    checkmate::check_class(loader, "rinja_loader")
  )
  if (is.character(loader)) {
    loader <- path_loader(loader)
  }

  qassert(block_open, "S1")
  qassert(block_close, "S1")
  qassert(variable_open, "S1")
  qassert(variable_close, "S1")
  qassert(comment_open, "S1")
  qassert(comment_close, "S1")
  qassert(line_statement, c("0", "S1"))
  qassert(trim_blocks, "B1")
  qassert(lstrip_blocks, "B1")

  delimiters <- c(
    block_open, block_close,
    variable_open, variable_close,
    comment_open, comment_close,
    line_statement
  )
  if (anyDuplicated(delimiters)) {
    stop("Found conflicting delimiters.")
  }

  if (is.null(line_statement)) {
    line_statement <- ""
  }

  structure(list(
    loader = loader,
    variable_open = variable_open,
    variable_close = variable_close,
    block_open = block_open,
    block_close = block_close,
    line_statement = line_statement,
    comment_open = comment_open,
    comment_close = comment_close,
    trim_blocks = trim_blocks,
    lstrip_blocks = lstrip_blocks
  ), class = "rinja_engine_config")
}

#' @export
print.rinja_engine_config <- function(x, ...) {
  if (is.null(x$loader)) {
    cat("Loader: disabled")
  } else {
    print(x$loader)
  }

  cat(
    "Syntax:",
    x$block_open, "block", x$block_close,
    x$variable_open, "variable", x$variable_close,
    x$comment_open, "comment", x$comment_close
  )

  invisible(x)
}
