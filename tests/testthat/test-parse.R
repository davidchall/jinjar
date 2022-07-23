test_that("input validation works", {
  expect_error(parse_template("Hey", .config = TRUE))
})

test_that("storing parsed document works", {
  x <- parse_template("Hello {{ name }}!")

  expect_s3_class(x, "jinjar_template")

  expect_equal(render(x, name = "world"), "Hello world!")
  expect_equal(render(x, name = "David"), "Hello David!")
})

cli::test_that_cli("printing parsed document works", {
  template <- 'Humans of A New Hope
{# put a comment here #}
{% for person in people -%}
{% if "A New Hope" in person.films and default(person.species, "Unknown") == "Human" -%}
* {{ person.name }} ({{ person.homeworld }})
{% endif -%}
{% endfor -%}
'

  x <- parse_template(template)
  expect_snapshot(print(x, n = Inf))
  expect_snapshot(print(x, n = 5))

  expect_error(print(x, n = 2.5))
})

cli::test_that_cli("print spans with overlap works", {
  tmpl <- "{# {{ this }} is a {{ comment }} #}"
  x <- parse_template(tmpl)
  expect_snapshot(print(x))
})

cli::test_that_cli("parse error", {
  expect_snapshot_error(parse_template("Hello {{ name }!"), class = "jinjar_parser_error")
})
