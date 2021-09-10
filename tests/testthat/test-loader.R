test_that("path_loader works", {
  expect_error(path_loader("unknown"))

  x <- path_loader(fs::path_home_r())
  expect_s3_class(x, c("path_loader", "jinjar_loader"))
  expect_equal(x$path, fs::path_home_r())
  expect_invisible(expect_output(print(x)))
})

test_that("package_loader works", {
  expect_error(package_loader("unknown"))

  x <- package_loader("base")
  expect_s3_class(x, c("path_loader", "jinjar_loader"))
  expect_equal(x, path_loader(fs::path_package("base")))
})

test_that("list_loader works", {
  expect_error(list_loader(list()))

  x <- list_loader(list("a" = "b"))
  expect_s3_class(x, c("list_loader", "jinjar_loader"))
  expect_equal(x$a, "b")
  expect_invisible(expect_output(print(x)))
})
