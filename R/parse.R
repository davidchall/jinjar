#' Parse template
#'
#' Sometimes you want to render multiple copies of a template, using different
#' sets of data variables. [parse_template()] returns an intermediate version
#' of the template, so you can [render()] repeatedly without re-parsing the
#' template syntax.
#'
#' @param .x The template. Choices:
#' * A template string.
#' * A path to a template file (use [fs::path()]).
#' @inheritParams render
#' @return A `"jinjar_template"` object.
#'
#' @seealso
#' * [render()] to render the final document using data variables.
#' * `vignette("template-syntax")` describes how to write templates.
#' @examples
#' x <- parse_template("Hello {{ name }}!")
#' render(x, name = "world")
#' @name parse
#' @export
parse_template <- function(.x, .config) {
  UseMethod("parse_template")
}

#' @rdname parse
#' @export
parse_template.character <- function(.x, .config = default_config()) {
  check_string(.x)
  if (!inherits(.config, "jinjar_config")) {
    cli::cli_abort("{.arg .config} must be a {.cls jinjar_config} object.")
  }

  structure(
    .x,
    config = .config,
    parsed = parse_(.x, .config),
    class = "jinjar_template"
  )
}

#' @rdname parse
#' @export
parse_template.fs_path <- function(.x, .config = default_config()) {
  read_utf8 <- function(path) {
    paste(readLines(path, encoding = "UTF-8", warn = FALSE), collapse = "\n")
  }

  if (inherits(.config$loader, "path_loader")) {
    if (!fs::path_has_parent(.x, .config$loader$path)) {
      .x <- fs::path_abs(.x, .config$loader$path)
    }
  }

  check_file_exists(.x)

  parse_template(read_utf8(.x), .config)
}

#' @export
print.jinjar_template <- function(x, ...) {
  config <- attr(x, "config")

  blocks <- rbind(
    find_blocks(x, "block", config$block_open, config$block_close),
    find_blocks(x, "variable", config$variable_open, config$variable_close),
    find_blocks(x, "comment", config$comment_open, config$comment_close)
  )

  # handle line statements
  if (nchar(config$line_statement) > 0) {
    blocks <- rbind(blocks, find_blocks(x, "block", config$line_statement, "\n"))
  }

  # sort in order of appearance
  blocks <- blocks[order(blocks$open),]

  print(blocks)

  ix_write <- 0
  output <- character()
  for (row in 1:nrow(blocks)) {
    ix_open <- blocks[row, "open"]
    ix_close <- blocks[row, "close"]

    if (ix_write < ix_open) {
      output <- c(output, substr(x, ix_write, ix_open - 1))
      ix_write <- ix_open
    }

    if (ix_write == ix_open) {
      output <- c(output, substr(x, ix_open, ix_close))
      ix_write <- ix_close + 1
    }
  }

  print(output)

  cat(x)
  invisible(x)
}

find_blocks <- function(x, type, open, close) {
  ix_open <- as.integer(gregexpr(open, x, fixed = TRUE)[[1]])
  ix_close <- as.integer(gregexpr(close, x, fixed = TRUE)[[1]])

  # no blocks found
  if (all(ix_open == -1L)) {
    return(data.frame(type = character(), open = integer(), close = integer()))
  }

  # ignore unmatched open/close patterns
  find_matching_close <- function(x) min(ix_close[ix_close > x])
  ix_close_match <- vapply(ix_open, find_matching_close, FUN.VALUE = 0L)

  ix_open <- ix_open[c(1, diff(ix_close_match)) != 0]
  ix_close <- ix_close[ix_close %in% ix_close_match]
  ix_close <- ix_close + nchar(close) - 1

  data.frame(type = type, open = ix_open, close = ix_close)
}
