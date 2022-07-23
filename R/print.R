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

#' @importFrom utils head
style_template <- function(x) {
  if (cli::num_ansi_colors() == 1) {
    return(x)
  }

  config <- attr(x, "config")

  # find spans
  spans <- rbind(
    find_spans(x, "block", config$block_open, config$block_close),
    find_spans(x, "variable", config$variable_open, config$variable_close),
    find_spans(x, "comment", config$comment_open, config$comment_close)
  )
  if (nchar(config$line_statement) > 0) {
    spans <- rbind(spans, find_spans(x, "block", config$line_statement, "\n"))
  }

  # sort spans in order of appearance
  spans <- spans[order(spans$ix_open),]

  # remove span overlaps
  latest_ix_close <- c(0, head(cummax(spans$ix_close), -1))
  spans <- spans[spans$ix_close > latest_ix_close,]

  # gaps are text spans
  text_spans <- data.frame(
    type = "text",
    ix_open = c(1, spans$ix_close + 1),
    ix_close = c(spans$ix_open - 1, nchar(x))
  )
  text_spans <- text_spans[text_spans$ix_open <= text_spans$ix_close,]

  # add text spans and sort again
  spans <- rbind(spans, text_spans)
  spans <- spans[order(spans$ix_open),]

  # style spans
  output <- mapply(style_span, x, spans$type, spans$ix_open, spans$ix_close)

  # stitch spans
  paste0(output, collapse = "")
}

find_spans <- function(x, type, open, close) {
  ix_open <- gregexpr(open, x, fixed = TRUE)[[1]]
  ix_close <- gregexpr(close, x, fixed = TRUE)[[1]]

  # no spans found
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

style_span <- function(x, type, ix_open, ix_close) {
  txt_span <- substr(x, ix_open, ix_close)

  if (type == "comment") {
    style_comment(txt_span)
  } else if (type == "block") {
    style_block(txt_span)
  } else if (type == "variable") {
    style_variable(txt_span)
  } else {
    txt_span
  }
}

style_comment <- function(x) cli::style_italic(cli::col_grey(x))
style_block <- cli::col_blue
style_variable <- cli::col_green
