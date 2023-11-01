test_that("input validation works", {
  expect_error(render())
})

test_that("templating features work", {
  expect_equal(
    render("Hello {{ name }}!", name = "world"),
    "Hello world!"
  )

  expect_equal(
    render("{Hello {{ name }}!}", name = "world"),
    "{Hello world!}"
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
    "templates/foo" = src,
    "templates/bar" = aux
  ), {

    expect_error(render(fs::path("foo"), name = "world"))
    expect_snapshot(render(
      fs::path("templates/foo"),
      name = "world",
      .config = jinjar_config(ignore_missing_files = TRUE)
    ))
    expect_snapshot(render(
      fs::path("foo"),
      name = "world",
      .config = jinjar_config(path_loader(fs::path_wd("templates")))
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

test_that("quote_sql() works", {
  expect_equal(
    render("WHERE x = {{ quote_sql(col) }}", col = "world"),
    "WHERE x = 'world'"
  )
  expect_equal(
    render("WHERE x = {{ quote_sql(col) }}", col = "Wayne's World"),
    "WHERE x = 'Wayne''s World'"
  )
  expect_equal(
    render("WHERE x = {{ quote_sql(col) }}", col = 1L),
    "WHERE x = 1"
  )
  expect_equal(
    render("WHERE x = {{ quote_sql(col) }}", col = 2.5),
    "WHERE x = 2.5"
  )
  expect_equal(
    render("WHERE x = {{ quote_sql(col) }}", col = TRUE),
    "WHERE x = TRUE"
  )
  expect_equal(
    render("WHERE x = {{ quote_sql(col) }}", col = FALSE),
    "WHERE x = FALSE"
  )
  expect_equal(
    render("WHERE x = {{ quote_sql(col) }}", col = NA),
    "WHERE x = NULL"
  )
  expect_equal(
    render("WHERE x IN ({{ quote_sql(col) }})", col = c("world", "galaxy")),
    "WHERE x IN ('world', 'galaxy')"
  )
  expect_equal(
    render("WHERE x IN ({{ quote_sql(col) }})", col = c(1, 4, 6)),
    "WHERE x IN (1, 4, 6)"
  )
})

cli::test_that_cli("render error", {
  expect_snapshot(render("Hello {{ name }}!"), error = TRUE)
  expect_snapshot(render('{% include "missing.html" %}'), error = TRUE)

  expect_snapshot(
    render("{% for x in vec %}{{ x }}{% endfor %}", vec = "world"),
    error = TRUE
  )
})

cli::test_that_cli("JSON encoding error", {
  x <- parse_template("Hello {{ name }}!")

  expect_snapshot(jinjar:::with_catch_cpp_errors({
    jinjar:::render_(attr(x, "parsed"), '{"name": "world"]}')
  }), error = TRUE)
})
