#' Print a template
#'
#' Once a template has been parsed, it can be printed with color highlighting of
#' the templating blocks.
#'
#' @param x A parsed template (use [parse_template()]).
#' @param n Number of lines to show. If `Inf`, will print all lines. Default: `10`.
#' @inheritParams rlang::args_dots_empty
#' @examples
#' input <- '<!DOCTYPE html>
#' <html lang="en">
#' <head>
#'     <title>{{ title }}</title>
#' </head>
#' <body>
#'     <ul id="navigation">
#'     {% for item in navigation -%}
#'         <li><a href="{{ item.href }}">{{ item.caption }}</a></li>
#'     {% endfor -%}
#'     </ul>
#' {# a comment #}
#' </body>
#' </html>'
#'
#' x <- parse_template(input)
#'
#' print(x)
#'
#' print(x, n = Inf)
#' @rdname print
#' @export
print.jinjar_template <- function(x, ..., n = 10) {
  check_dots_empty()
  check_count(n, inf = TRUE)
  n_more <- 0L

  # truncate output
  if (is.finite(n)) {
    lines <- strsplit(x, "\n", fixed = TRUE)[[1]]
    n_found <- length(lines)

    if (n_found > n) {
      attrs <- attributes(x)
      x <- paste0(lines[1:n], collapse = "\n")
      attributes(x) <- attrs

      n_more <- n_found - n
    }
  }

  cli::cli_verbatim(style_template(x))
  if (n_more > 0) {
    dots <- cli::symbol$ellipsis
    subtle <- cli::make_ansi_style("grey60")
    cli::cli_alert_info(subtle("{dots} with {n_more} more line{?s}"))
  }

  invisible(x)
}

style_template <- function(x) {
  if (cli::num_ansi_colors() == 1) {
    return(x)
  }

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
      output <- c(output, style_block(x, "text", ix_write, row$ix_open - 1))
      ix_write <- row$ix_open
    }

    if (ix_write == row$ix_open) {
      output <- c(output, style_block(x, row$type, row$ix_open, row$ix_close))
      ix_write <- row$ix_close + 1
    }
  }
  if (ix_write <= nchar(x)) {
    output <- c(output, style_block(x, "text", ix_write, nchar(x)))
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
    cli::style_italic(cli::col_grey(txt_block))
  } else if (type == "block") {
    cli::col_blue(txt_block)
  } else if (type == "variable") {
    cli::col_green(txt_block)
  } else {
    txt_block
  }
}
