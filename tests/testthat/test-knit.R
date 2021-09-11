render_html <- function(rmd_path) {
  html_path <- tempfile(fileext = ".html")
  rmarkdown::render(rmd_path, output_file = html_path, quiet = TRUE)
  html_path
}

test_that("knit engine works", {
  if (!rmarkdown::pandoc_available())
    skip("rmarkdown requires pandoc")

  expect_snapshot_file(
    render_html("knit-engine.Rmd"),
    "output.html",
    compare = compare_file_text
  )
})
