# include tag

    Code
      render(fs::path("templates/foo"), name = "world", .config = jinjar_config(
        ignore_missing_files = TRUE))
    Output
      [1] "Welcome: "

---

    Code
      render(fs::path("foo"), name = "world", .config = jinjar_config(path_loader(fs::path_wd(
        "templates"))))
    Output
      [1] "Welcome: Hello world!\n"

---

    Code
      render(src, name = "world", .config = list_config)
    Output
      [1] "Welcome: Hello world!"

# extends tag

    Code
      render(fs::path("foo"), name = "world", .config = jinjar_config(
        ignore_missing_files = TRUE))
    Output
      [1] "world"

---

    Code
      render(fs::path("foo"), name = "world", .config = jinjar_config(path_loader(fs::path_wd())))
    Output
      [1] "Hello world!\n"

---

    Code
      render(src, name = "world", .config = list_config)
    Output
      [1] "Hello world!"

# render error [plain]

    Code
      render("Hello {{ name }}!")
    Condition
      Error in `render()`:
      ! Problem encountered while rendering template.
      Caused by error:
      ! Variable 'name' not found.
      i Error occurred on line 1 and column 10.

---

    Code
      render("{% include \"missing.html\" %}")
    Condition
      Error in `render()`:
      ! Problem encountered while rendering template.
      Caused by error:
      ! Include 'missing.html' not found.
      i Error occurred on line 1 and column 12.

---

    Code
      render("{% for x in vec %}{{ x }}{% endfor %}", vec = "world")
    Condition
      Error in `render()`:
      ! Problem encountered while rendering template.
      Caused by error:
      ! Object must be an array.
      i Have you forgotten to wrap a length-1 vector with I()?
      i Error occurred on line 1 and column 10.

# render error [ansi]

    Code
      render("Hello {{ name }}!")
    Condition
      [1m[33mError[39m in `render()`:[22m
      [33m![39m Problem encountered while rendering template.
      [1mCaused by error:[22m
      [1m[22m[33m![39m Variable 'name' not found.
      [36mi[39m Error occurred on [32mline 1[39m and [32mcolumn 10[39m.

---

    Code
      render("{% include \"missing.html\" %}")
    Condition
      [1m[33mError[39m in `render()`:[22m
      [33m![39m Problem encountered while rendering template.
      [1mCaused by error:[22m
      [1m[22m[33m![39m Include 'missing.html' not found.
      [36mi[39m Error occurred on [32mline 1[39m and [32mcolumn 12[39m.

---

    Code
      render("{% for x in vec %}{{ x }}{% endfor %}", vec = "world")
    Condition
      [1m[33mError[39m in `render()`:[22m
      [33m![39m Problem encountered while rendering template.
      [1mCaused by error:[22m
      [1m[22m[33m![39m Object must be an array.
      [36mi[39m Have you forgotten to wrap a length-1 vector with I()?
      [36mi[39m Error occurred on [32mline 1[39m and [32mcolumn 10[39m.

# render error [unicode]

    Code
      render("Hello {{ name }}!")
    Condition
      Error in `render()`:
      ! Problem encountered while rendering template.
      Caused by error:
      ! Variable 'name' not found.
      ℹ Error occurred on line 1 and column 10.

---

    Code
      render("{% include \"missing.html\" %}")
    Condition
      Error in `render()`:
      ! Problem encountered while rendering template.
      Caused by error:
      ! Include 'missing.html' not found.
      ℹ Error occurred on line 1 and column 12.

---

    Code
      render("{% for x in vec %}{{ x }}{% endfor %}", vec = "world")
    Condition
      Error in `render()`:
      ! Problem encountered while rendering template.
      Caused by error:
      ! Object must be an array.
      ℹ Have you forgotten to wrap a length-1 vector with I()?
      ℹ Error occurred on line 1 and column 10.

# render error [fancy]

    Code
      render("Hello {{ name }}!")
    Condition
      [1m[33mError[39m in `render()`:[22m
      [33m![39m Problem encountered while rendering template.
      [1mCaused by error:[22m
      [1m[22m[33m![39m Variable 'name' not found.
      [36mℹ[39m Error occurred on [32mline 1[39m and [32mcolumn 10[39m.

---

    Code
      render("{% include \"missing.html\" %}")
    Condition
      [1m[33mError[39m in `render()`:[22m
      [33m![39m Problem encountered while rendering template.
      [1mCaused by error:[22m
      [1m[22m[33m![39m Include 'missing.html' not found.
      [36mℹ[39m Error occurred on [32mline 1[39m and [32mcolumn 12[39m.

---

    Code
      render("{% for x in vec %}{{ x }}{% endfor %}", vec = "world")
    Condition
      [1m[33mError[39m in `render()`:[22m
      [33m![39m Problem encountered while rendering template.
      [1mCaused by error:[22m
      [1m[22m[33m![39m Object must be an array.
      [36mℹ[39m Have you forgotten to wrap a length-1 vector with I()?
      [36mℹ[39m Error occurred on [32mline 1[39m and [32mcolumn 10[39m.

# JSON encoding error [plain]

    Code
      jinjar:::with_catch_cpp_errors({
        jinjar:::render_(attr(x, "parsed"), "{\"name\": \"world\"]}")
      })
    Condition
      Error:
      ! Problem encountered while decoding JSON data.
      i This is an internal error that was detected in the jinjar package.
        Please report it at <https://github.com/davidchall/jinjar/issues> with a reprex (<https://tidyverse.org/help/>) and the full backtrace.
      Caused by error:
      ! [json.exception.parse_error.101] parse error at line 1, column 17: syntax error while parsing object - unexpected ']'; expected '}'
      i JSON object: "{\"name\": \"world\"]}"

# JSON encoding error [ansi]

    Code
      jinjar:::with_catch_cpp_errors({
        jinjar:::render_(attr(x, "parsed"), "{\"name\": \"world\"]}")
      })
    Condition
      [1m[33mError[39m:[22m
      [33m![39m Problem encountered while decoding JSON data.
      [34mi[39m This is an internal error that was detected in the [34mjinjar[39m package.
        Please report it at [3m[34m<https://github.com/davidchall/jinjar/issues>[39m[23m with a reprex ([3m[34m<https://tidyverse.org/help/>[39m[23m) and the full backtrace.
      [1mCaused by error:[22m
      [1m[22m[33m![39m [json.exception.parse_error.101] parse error at line 1, column 17: syntax error while parsing object - unexpected ']'; expected '}'
      [36mi[39m JSON object: [34m"{\"name\": \"world\"]}"[39m

# JSON encoding error [unicode]

    Code
      jinjar:::with_catch_cpp_errors({
        jinjar:::render_(attr(x, "parsed"), "{\"name\": \"world\"]}")
      })
    Condition
      Error:
      ! Problem encountered while decoding JSON data.
      ℹ This is an internal error that was detected in the jinjar package.
        Please report it at <https://github.com/davidchall/jinjar/issues> with a reprex (<https://tidyverse.org/help/>) and the full backtrace.
      Caused by error:
      ! [json.exception.parse_error.101] parse error at line 1, column 17: syntax error while parsing object - unexpected ']'; expected '}'
      ℹ JSON object: "{\"name\": \"world\"]}"

# JSON encoding error [fancy]

    Code
      jinjar:::with_catch_cpp_errors({
        jinjar:::render_(attr(x, "parsed"), "{\"name\": \"world\"]}")
      })
    Condition
      [1m[33mError[39m:[22m
      [33m![39m Problem encountered while decoding JSON data.
      [34mℹ[39m This is an internal error that was detected in the [34mjinjar[39m package.
        Please report it at [3m[34m<https://github.com/davidchall/jinjar/issues>[39m[23m with a reprex ([3m[34m<https://tidyverse.org/help/>[39m[23m) and the full backtrace.
      [1mCaused by error:[22m
      [1m[22m[33m![39m [json.exception.parse_error.101] parse error at line 1, column 17: syntax error while parsing object - unexpected ']'; expected '}'
      [36mℹ[39m JSON object: [34m"{\"name\": \"world\"]}"[39m

