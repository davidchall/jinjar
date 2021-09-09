test_that("input validation works", {
  expect_error(render())
})

test_that("templating features work", {
  expect_equal(
    render("Hello {{ name }}!", list(name = "world")),
    "Hello world!"
  )
})
