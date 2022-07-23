test_that("input validation works", {
  expect_error(jinjar_config(loader = 2))
  expect_error(jinjar_config(block_open = ""))
  expect_error(jinjar_config(block_open = NA_character_))
  expect_error(jinjar_config(trim_blocks = NA))
  expect_snapshot_error(jinjar_config(block_open = "{{", variable_open = "{{"))
})

cli::test_that_cli("default works", {
  x <- jinjar_config()
  expect_s3_class(x, "jinjar_config")
  expect_null(x$loader)
  expect_snapshot(print(x))
})

cli::test_that_cli("string loader works", {
  test_path <- fs::path_home_r()

  x <- jinjar_config(test_path)
  expect_s3_class(x, "jinjar_config")
  expect_equal(x$loader, path_loader(test_path))
  expect_snapshot(
    print(x),
    transform = function(x) gsub(test_path, "/path/to/templates", x, fixed = TRUE)
  )
})
