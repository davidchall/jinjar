# jinjar 0.3.2

Fix for CRAN checks.


# jinjar 0.3.1

* Fixed a bug where disabling line statements could raise an error during template parsing. Since line statements are disabled by default, this error could be encountered quite easily (#31).
* `quote_sql()` now escapes single-quotes using an additional single-quote (#30).
* Fixed edge case in how error messages are formatted (#32).
* Documented how `render()` can preserve length-1 vectors (#27).


# jinjar 0.3.0

This release provides several quality-of-life improvements.

* `print.jinjar_template()` now highlights templating blocks using {cli} (#18).
    * Variables are green
    * Control blocks are blue
    * Comments are italic grey
* `print.jinjar_template()` gains an `n` argument to control the number of lines displayed (#18).
* `jinjar_config()` objects are now printed using {cli} (#22).
* Exceptions raised by C++ code are now converted to R errors (#20).


# jinjar 0.2.0

* New `parse_template()` to parse a template once and `render()` it multiple times (#13).
* New template function `quote_sql()` simplifies writing SQL queries. See `vignette("template-syntax")` for details (#14).

# jinjar 0.1.1

* `path_loader()` now correctly finds template files outside the working directory (#11).

# jinjar 0.1.0

Initial version on CRAN.
