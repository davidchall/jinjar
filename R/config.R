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
#'   * Path to template directory.
#'   * A [`loader`] object.
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
#' @param ignore_missing_files Ignore `include` or `extends` statements when
#'   the auxiliary template cannot be found. If `FALSE` (default), then an error
#'   is raised.
#' @return A `"jinjar_config"` object.
#'
#' @examples
#' jinjar_config()
#' @export
jinjar_config <- function(loader = NULL,
                          block_open = "{%",
                          block_close = "%}",
                          variable_open = "{{",
                          variable_close = "}}",
                          comment_open = "{#",
                          comment_close = "#}",
                          line_statement = NULL,
                          trim_blocks = FALSE,
                          lstrip_blocks = FALSE,
                          ignore_missing_files = FALSE) {
  checkmate::assert(
    checkmate::check_null(loader),
    checkmate::check_directory_exists(loader),
    checkmate::check_class(loader, "jinjar_loader")
  )
  if (is.character(loader)) {
    loader <- path_loader(loader)
  }

  checkmate::assert_string(block_open, min.chars = 1)
  checkmate::assert_string(block_close, min.chars = 1)
  checkmate::assert_string(variable_open, min.chars = 1)
  checkmate::assert_string(variable_close, min.chars = 1)
  checkmate::assert_string(comment_open, min.chars = 1)
  checkmate::assert_string(comment_close, min.chars = 1)
  checkmate::assert_string(line_statement, min.chars = 1, null.ok = TRUE)
  checkmate::assert_flag(trim_blocks)
  checkmate::assert_flag(lstrip_blocks)
  checkmate::assert_flag(ignore_missing_files)

  delimiters <- c(
    variable_open = variable_open,
    variable_close = variable_close,
    block_open = block_open,
    block_close = block_close,
    line_statement = line_statement %||% "",
    comment_open = comment_open,
    comment_close = comment_close
  )
  if (anyDuplicated(delimiters)) {
    conflicts <- delimiters[duplicated(delimiters) | duplicated(delimiters, fromLast = TRUE)]
    stop(
      paste("Conflicting delimiters:", paste(names(conflicts), collapse = ", ")),
      call. = FALSE
    )
  }

  structure(c(as.list(delimiters), list(
    loader = loader,
    trim_blocks = trim_blocks,
    lstrip_blocks = lstrip_blocks,
    ignore_missing_files = ignore_missing_files
  )), class = "jinjar_config")
}

#' @export
print.jinjar_config <- function(x, ...) {
  if (is.null(x$loader)) {
    cat("Loader: disabled\n")
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

#' @rdname jinjar_config
#' @export
default_config <- function() {
  config <- getOption("jinjar.default_config")
  if (is.null(config)) {
    config <- jinjar_config()
    options("jinjar.default_config" = config)
  }

  config
}
