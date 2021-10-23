test_that("dynamic dots work", {
  expect_snapshot_error(encode(a = 1, a = "b"))
  expect_snapshot_error(encode(a = 1, "b", mtcars))

  res <- jsonlite::toJSON(list(a = 1), auto_unbox = TRUE)
  expect_equal(encode(a = 1), res)
  expect_equal(encode(!!!list(a = 1)), res)
})
