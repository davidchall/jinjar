to_sentence_case <- function(x) {
  paste0(
    toupper(substr(x, 1, 1)),
    substr(x, 2, nchar(x)),
    ifelse(substr(x, nchar(x), nchar(x)) == ".", "", ".")
  )
}

stop_inja <- function(type, message, line, column) {
  cls <- c(paste0("jinjar_", type), "jinjar_error")

  msg <- c(
    to_sentence_case(message),
    "i" = "Error occurred on {.field line {line}} and {.field column {column}}."
  )

  cli::cli_abort(msg, class = cls, call = NULL)
}

stop_json <- function(message, data) {
  cls <- c("jinjar_json_error", "jinjar_error")

  msg <- c(
    message,
    "i" = "JSON object: {.val {data}}"
  )

  cli::cli_abort(msg, class = cls, call = NULL)
}

with_catch_cpp_errors <- function(expr, call = caller_env()) {
  try_fetch(
    expr,
    jinjar_file_error = function(cnd) {
      abort("Problem encountered while reading template.", parent = cnd, call = call)
    },
    jinjar_parser_error = function(cnd) {
      abort("Problem encountered while parsing template.", parent = cnd, call = call)
    },
    jinjar_render_error = function(cnd) {
      abort("Problem encountered while rendering template.", parent = cnd, call = call)
    },
    jinjar_json_error = function(cnd) {
      # use .internal because JSON was poorly encoded by jinjar
      abort("Problem encountered while decoding JSON data.", parent = cnd, call = call, .internal = TRUE)
    }
  )
}
