
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jinjar

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/jinjar)](https://CRAN.R-project.org/package=jinjar)
[![Codecov test
coverage](https://codecov.io/gh/davidchall/jinjar/branch/master/graph/badge.svg)](https://codecov.io/gh/davidchall/jinjar?branch=master)
[![R-CMD-check](https://github.com/davidchall/jinjar/workflows/R-CMD-check/badge.svg)](https://github.com/davidchall/jinjar/actions)
<!-- badges: end -->

jinjar is a templating engine for R, powered by the
[inja](https://github.com/pantor/inja) C++ library and inspired by the
[jinja](https://jinja.palletsprojects.com/) Python package.

## Installation

You can install the development version from GitHub:

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

Here’s a more advanced example, using loops and conditional statements:

``` r
template <- '
{% for person in people -%}
{%- if "A New Hope" in person.films and default(person.species, "Unknown") == "Human" -%}
  * {{ person.name }} ({{ person.homeworld }})
{%- endif -%}
{%- endfor %}
'

text <- render(template, people = dplyr::starwars)
writeLines(text)
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
