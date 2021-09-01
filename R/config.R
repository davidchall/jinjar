#' Configure the templating engine
#'
#' @description
#' Create an object that configures how the templating engine behaves (e.g.
#' customize the syntax delimiters). The default values have been chosen to
#' match the Jinja defaults.
#'
#' The equivalent Jinja class is `Environment`, but this term has significance
#' in R.
#'
#' @param search_path Path to search for template files. If `NULL` (the default),
#'   searching the file system is disabled.
#' @param statement_open,statement_close The opening and closing delimiters
#'   for statements (i.e. control structures).
#'   Default: \verb{"\{\%"} and \verb{"\%\}"}.
#' @param line_statement The opening delimiter for an inline statement.
#'   Default: `"##"`
#' @param expression_open,expression_close The opening and closing delimiters
#'   for expressions (i.e. printed in rendered output).
#'   Default: `"{{"` and `"}}"`.
#' @param comment_open,comment_close The opening and closing delimiters
#'   for comments (i.e. removed from rendered output).
#'   Default: `"{#"` and `"#}"`.
#' @param trim_blocks Remove first newline after a block. Default: `FALSE`.
#' @param lstrip_blocks Remove inline whitespace before a block. Default: `FALSE`.
#' @return
#'   * `engine_config()` returns a `"rinja_engine_config"` object.
#'   * `is_engine_config()` returns a logical scalar.
#'
#' @examples
#' engine_config()
#' @export
engine_config <- function(search_path = NULL,
                          statement_open = "{%",
                          statement_close = "%}",
                          line_statement = "##",
                          expression_open = "{{",
                          expression_close = "}}",
                          comment_open = "{#",
                          comment_close = "#}",
                          trim_blocks = FALSE,
                          lstrip_blocks = FALSE) {

  if (!is.null(search_path)) assert_string(search_path)
  assert_string(statement_open)
  assert_string(statement_close)
  assert_string(line_statement)
  assert_string(expression_open)
  assert_string(expression_close)
  assert_string(comment_open)
  assert_string(comment_close)
  assert_bool(trim_blocks)
  assert_bool(lstrip_blocks)

  delimiters <- c(
    statement_open, statement_close, line_statement,
    expression_open, expression_close,
    comment_open, comment_close
  )
  if (anyDuplicated(delimiters)) {
    stop("Found conflicting delimiters.")
  }

  structure(list(
    search_path = search_path,
    expression_open = expression_open,
    expression_close = expression_close,
    statement_open = statement_open,
    statement_close = statement_close,
    line_statement = line_statement,
    comment_open = comment_open,
    comment_close = comment_close,
    trim_blocks = trim_blocks,
    lstrip_blocks = lstrip_blocks
  ), class = "rinja_engine_config")
}

assert_string <- function(x) {
  stopifnot(is.character(x), length(x) == 1, !is.na(x))
}

assert_bool <- function(x) {
  stopifnot(is.logical(x), length(x) == 1, !is.na(x))
}

#' @param x An object
#' @rdname engine_config
#' @export
is_engine_config <- function(x) {
  inherits(x, "rinja_engine_config")
}

#' @export
print.rinja_engine_config <- function(x, ...) {
  if (is.null(x$search_path)) {
    cat("File search: disabled")
  } else {
    cat("File search:", x$search_path)
  }

  cat(
    "\nSyntax:",
    x$statement_open, "statement", x$statement_close,
    x$expression_open, "expression", x$expression_close,
    x$comment_open, "comment", x$comment_close
  )

  invisible(x)
}
