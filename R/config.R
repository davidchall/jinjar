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

  if (!(is_null(loader) || is_string(loader) || inherits(loader, "jinjar_loader"))) {
    cli::cli_abort("{.arg loader} must be NULL, a path, or a loader object", arg = "loader")
  }
  if (is.character(loader)) {
    loader <- path_loader(loader)
  }

  check_string(block_open)
  check_string(block_close)
  check_string(variable_open)
  check_string(variable_close)
  check_string(comment_open)
  check_string(comment_close)
  check_string(line_statement %||% "")
  check_bool(trim_blocks)
  check_bool(lstrip_blocks)
  check_bool(ignore_missing_files)

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
    cli::cli_abort("Conflicting delimiters: {.arg {names(conflicts)}}")
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
  cli::cli({
    cli::cli_h1("Template configuration")

    if (is.null(x$loader)) {
      cli::cli_text("{.strong Loader:} disabled")
    } else {
      print(x$loader)
    }

    cli::cli_text(
      "{.strong Syntax:} ",
      style_block("{x$block_open} block {x$block_close}"), " ",
      style_variable("{x$variable_open} variable {x$variable_close}"), " ",
      style_comment("{x$comment_open} comment {x$comment_close}")
    )
  })

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
