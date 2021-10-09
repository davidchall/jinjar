test_that("input validation works", {
  expect_error(render())
})

test_that("templating features work", {
  expect_equal(
    render("Hello {{ name }}!", name = "world"),
    "Hello world!"
  )
})

test_that("template files work", {
  with_dir_tree(list("foo" = "Hello {{ name }}!"), {
    path_config <- jinjar_config(fs::path_wd())

    expect_equal(
      render(fs::path("foo"), name = "world"),
      "Hello world!"
    )
    expect_equal(
      render(fs::path_wd("foo"), name = "world"),
      "Hello world!"
    )
    expect_equal(
      render(fs::path("foo"), name = "world", .config = path_config),
      "Hello world!"
    )
    expect_equal(
      render(fs::path_wd("foo"), name = "world", .config = path_config),
      "Hello world!"
    )
    expect_error(render(fs::path_home_r("foo")))
  })
})

test_that("include tag", {
  src <- "Welcome: {% include \"bar\" %}"
  aux <- "Hello {{ name }}!"

  with_dir_tree(list(
    "foo" = src,
    "bar" = aux
  ), {

    expect_error(render(fs::path("foo"), name = "world"))
    expect_snapshot(render(
      fs::path("foo"),
      name = "world",
      .config = jinjar_config(ignore_missing_files = TRUE)
    ))
    expect_snapshot(render(
      fs::path("foo"),
      name = "world",
      .config = jinjar_config(path_loader(fs::path_wd()))
    ))
  })

  list_config <- jinjar_config(list_loader(list(
    "bar" = aux
  )))
  expect_error(render(src, name = "world"))
  expect_snapshot(render(src, name = "world", .config = list_config))
})

test_that("extends tag", {
  src <- "{% extends \"bar\" %}{% block name %}world{% endblock %}"
  aux <- "Hello {% block name %}{% endblock %}!"

  with_dir_tree(list(
    "foo" = src,
    "bar" = aux
  ), {
    expect_error(render(fs::path("foo"), name = "world"))
    expect_snapshot(render(
      fs::path("foo"),
      name = "world",
      .config = jinjar_config(ignore_missing_files = TRUE)
    ))
    expect_snapshot(render(
      fs::path("foo"),
      name = "world",
      .config = jinjar_config(path_loader(fs::path_wd()))
    ))
  })

  list_config <- jinjar_config(list_loader(list(
    "bar" = aux
  )))
  expect_error(render(src, name = "world"))
  expect_snapshot(render(src, name = "world", .config = list_config))
})

test_that("escape_html() works", {
  expect_equal(
    render("{{ escape_html(x) }}", x = '&<>"&'),
    "&amp;&lt;&gt;&quot;&amp;"
  )
})
