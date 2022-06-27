# jinjar (development version)

* When printing parsed template objects, output is now stylized using the cli package.
    * Variables are green
    * Control blocks are blue
    * Comments are italic grey


# jinjar 0.2.0

* New `parse_template()` to parse a template once and `render()` it multiple times (#13).
* New template function `quote_sql()` simplifies writing SQL queries. See `vignette("template-syntax")` for details (#14).

# jinjar 0.1.1

* `path_loader()` now correctly finds template files outside the working directory (#11).

# jinjar 0.1.0

Initial version on CRAN.
