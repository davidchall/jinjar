test_that("input validation works", {
  expect_error(engine_config(loader = 2))
  expect_error(engine_config(block_open = ""))
  expect_error(engine_config(block_open = NA_character_))
  expect_error(engine_config(trim_blocks = NA))
  expect_snapshot_error(engine_config(block_open = "{{", variable_open = "{{"))
})

test_that("default works", {
  x <- engine_config()
  expect_s3_class(x, "jinjar_engine_config")
  expect_null(x$loader)
  expect_snapshot(print(x))
})

test_that("string loader works", {
  x <- engine_config(fs::path_home_r())
  expect_s3_class(x, "jinjar_engine_config")
  expect_equal(x$loader, path_loader(fs::path_home_r()))
  expect_invisible(expect_output(print(x)))
})
