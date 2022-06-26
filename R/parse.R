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
  if (cli::num_ansi_colors() > 1) {
    cli::cli_verbatim(style_template(x))
  } else {
    cat(x)
  }

  invisible(x)
}

style_template <- function(x) {
  config <- attr(x, "config")

  # find blocks
  blocks <- rbind(
    find_blocks(x, "block", config$block_open, config$block_close),
    find_blocks(x, "variable", config$variable_open, config$variable_close),
    find_blocks(x, "comment", config$comment_open, config$comment_close)
  )

  # handle line statements
  if (nchar(config$line_statement) > 0) {
    blocks <- rbind(blocks, find_blocks(x, "block", config$line_statement, "\n"))
  }

  # sort blocks in order of appearance
  blocks <- blocks[order(blocks$ix_open),]

  # style blocks
  ix_write <- 0
  output <- character()
  for (i_row in 1:nrow(blocks)) {
    row <- blocks[i_row,]

    if (ix_write < row$ix_open) {
      output <- c(output, style_block(x, "", ix_write, row$ix_open - 1))
      ix_write <- row$ix_open
    }

    if (ix_write == row$ix_open) {
      output <- c(output, style_block(x, row$type, row$ix_open, row$ix_close))
      ix_write <- row$ix_close + 1
    }
  }
  if (ix_write < nchar(x)) {
    output <- c(output, style_block(x, "", ix_write, nchar(x)))
  }

  # stitch blocks
  paste0(output, collapse = "")
}

find_blocks <- function(x, type, open, close) {
  ix_open <- gregexpr(open, x, fixed = TRUE)[[1]]
  ix_close <- gregexpr(close, x, fixed = TRUE)[[1]]

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

  data.frame(type, ix_open, ix_close)
}

style_block <- function(x, type, ix_open, ix_close) {
  txt_block <- substr(x, ix_open, ix_close)

  if (type == "comment") {
    cli::col_grey(txt_block)
  } else if (type == "block") {
    cli::col_blue(txt_block)
  } else if (type == "variable") {
    cli::col_green(txt_block)
  } else {
    txt_block
  }
}
