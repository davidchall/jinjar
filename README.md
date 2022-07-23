
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jinjar

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/jinjar)](https://CRAN.R-project.org/package=jinjar)
[![Codecov test
coverage](https://codecov.io/gh/davidchall/jinjar/branch/master/graph/badge.svg)](https://app.codecov.io/gh/davidchall/jinjar?branch=master)
[![R-CMD-check](https://github.com/davidchall/jinjar/workflows/R-CMD-check/badge.svg)](https://github.com/davidchall/jinjar/actions)
<!-- badges: end -->

jinjar is a templating engine for R, inspired by the
[Jinja](https://jinja.palletsprojects.com/) Python package and powered
by the [inja](https://github.com/pantor/inja) C++ library.

## Installation

You can install the released version of jinjar from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("jinjar")
```

Or you can install the development version from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("davidchall/jinjar")
```

## Usage

``` r
library(jinjar)

render("Hello {{ name }}!", name = "world")
#> [1] "Hello world!"
```

Here’s a more advanced example using loops and conditional statements.
The full list of supported syntax is described in
`vignette("template-syntax")`.

``` r
template <- 'Humans of A New Hope

{% for person in people -%}
{% if "A New Hope" in person.films and default(person.species, "Unknown") == "Human" -%}
* {{ person.name }} ({{ person.homeworld }})
{% endif -%}
{% endfor -%}
'

template |>
  render(people = dplyr::starwars) |>
  writeLines()
#> Humans of A New Hope
#> 
#> * Luke Skywalker (Tatooine)
#> * Darth Vader (Tatooine)
#> * Leia Organa (Alderaan)
#> * Owen Lars (Tatooine)
#> * Beru Whitesun lars (Tatooine)
#> * Biggs Darklighter (Tatooine)
#> * Obi-Wan Kenobi (Stewjon)
#> * Wilhuff Tarkin (Eriadu)
#> * Han Solo (Corellia)
#> * Wedge Antilles (Corellia)
#> * Jek Tono Porkins (Bestine IV)
#> * Raymus Antilles (Alderaan)
```

## Related work

An important characteristic of a templating engine is how much logic is
supported. This spectrum ranges from **logic-less** templates (i.e. only
variable substitution is supported) to **arbitrary code execution**.
Generally speaking, logic-less templates are easier to maintain because
their functionality is so restricted. But often the data doesn’t align
with how it should be rendered – templating logic offers the flexibility
to bridge this gap.

Fortunately, we already have very popular R packages that fall on
opposite ends of this spectrum:

-   [**whisker**](https://github.com/edwindj/whisker) – Implements the
    [Mustache](https://mustache.github.io) templating syntax. This is
    nearly **logic-less**, though some simple control flow is supported.
    Mustache templates are language agnostic (i.e. can be rendered by
    other Mustache implementations).
-   [**knitr**](https://yihui.org/knitr/) and
    [**rmarkdown**](https://github.com/rstudio/rmarkdown) – Allows
    **arbitrary code execution** to be knitted together with Markdown
    text content. It even supports [multiple language
    engines](https://bookdown.org/yihui/rmarkdown/language-engines.html)
    (e.g. R, Python, C++, SQL).

In contrast, jinjar strikes a balance inspired by the
[Jinja](https://jinja.palletsprojects.com/) Python package. It supports
more complex logic than whisker, but without the arbitrary code
execution of knitr.
