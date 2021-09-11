test_that("knit engine works", {
  if (!rmarkdown::pandoc_available())
    skip("rmarkdown requires pandoc")

  expect_success(rmarkdown::render(
    "knit-engine.Rmd",
    output_file = tempfile(fileext = ".html"),
    quiet = TRUE
  ))
})
