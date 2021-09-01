test_that("input validation works", {
  expect_error(engine_config(search_path = 2))
  expect_error(engine_config(statement_open = NA_character_))
  expect_error(engine_config(trim_blocks = NA))
  expect_error(engine_config(statement_open = "{{", expression_open = "{{"))
})

test_that("construction works", {
  expect_s3_class(engine_config(), "rinja_engine_config")
  expect_true(is_engine_config(engine_config()))
})
