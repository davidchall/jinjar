test_that("input validation works", {
  expect_error(engine_config(loader = 2))
  expect_error(engine_config(block_open = ""))
  expect_error(engine_config(block_open = NA_character_))
  expect_error(engine_config(trim_blocks = NA))
  expect_snapshot_error(engine_config(block_open = "{{", variable_open = "{{"))
})

test_that("construction works", {
  expect_s3_class(engine_config(), "rinja_engine_config")
})

test_that("printing works", {
  expect_snapshot(print(engine_config()))
})
