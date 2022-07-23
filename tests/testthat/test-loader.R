cli::test_that_cli("path_loader works", {
  expect_error(path_loader("unknown"))

  test_path <- fs::path_home_r()

  x <- path_loader(test_path)
  expect_s3_class(x, c("path_loader", "jinjar_loader"))
  expect_equal(x$path, test_path)
  expect_snapshot(
    print(x),
    transform = function(x) gsub(test_path, "/path/to/templates", x, fixed = TRUE)
  )
})

cli::test_that_cli("package_loader works", {
  expect_error(package_loader("unknown"))

  x <- package_loader("jinjar", "R")
  expect_s3_class(x, c("package_loader", "path_loader", "jinjar_loader"))
  expect_equal(x$path, fs::path_package("jinjar", "R"))
  expect_snapshot(print(x))
})

cli::test_that_cli("list_loader works", {
  expect_error(list_loader(list()))

  x <- list_loader(list("a" = "b"))
  expect_s3_class(x, c("list_loader", "jinjar_loader"))
  expect_equal(x$a, "b")

  short_names <- list(x = "a", y = "b", z = "c")
  long_names <- list(
    "here_is_a_very_long_template_name" = "a",
    "and_one_more_just_for_good_luck" = "b"
  )
  expect_snapshot({
    print(list_loader(short_names))
    print(list_loader(long_names))
  })
})
