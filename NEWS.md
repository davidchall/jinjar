# jinjar (development version)

* `print.jinjar_template()` now highlights templating blocks using {cli} (#18).
    * Variables are green
    * Control blocks are blue
    * Comments are italic grey
* `print.jinjar_template()` gains an `n` argument to control the number of lines displayed (#18).


# jinjar 0.2.0

* New `parse_template()` to parse a template once and `render()` it multiple times (#13).
* New template function `quote_sql()` simplifies writing SQL queries. See `vignette("template-syntax")` for details (#14).

# jinjar 0.1.1

* `path_loader()` now correctly finds template files outside the working directory (#11).

# jinjar 0.1.0

Initial version on CRAN.
