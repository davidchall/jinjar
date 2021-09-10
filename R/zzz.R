.onAttach <- function(...) {
  if (requireNamespace("knitr", quietly = TRUE)) {
    knit_engines <- get("knit_engines", envir = asNamespace("knitr"))
    knit_engines$set(jinjar = knit_jinjar)
  }
}

knit_jinjar <- function(options) {
  code <- paste(options$code, collapse = "\n")
  out <- jinjar::render(code, !!!options$data)
  knitr::engine_output(options, code, out)
}
