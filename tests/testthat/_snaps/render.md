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

    Problem encountered while rendering template.
    Caused by error:
    ! Variable 'name' not found.
    i Error occurred on line 1 and column 10.

---

    Problem encountered while rendering template.
    Caused by error:
    ! Include 'missing.html' not found.
    i Error occurred on line 1 and column 12.

# render error [ansi]

    Problem encountered while rendering template.
    [1mCaused by error:[22m
    [1m[22m[33m![39m Variable 'name' not found.
    [36mi[39m Error occurred on [32mline 1[39m and [32mcolumn 10[39m.

---

    Problem encountered while rendering template.
    [1mCaused by error:[22m
    [1m[22m[33m![39m Include 'missing.html' not found.
    [36mi[39m Error occurred on [32mline 1[39m and [32mcolumn 12[39m.

# render error [unicode]

    Problem encountered while rendering template.
    Caused by error:
    ! Variable 'name' not found.
    ℹ Error occurred on line 1 and column 10.

---

    Problem encountered while rendering template.
    Caused by error:
    ! Include 'missing.html' not found.
    ℹ Error occurred on line 1 and column 12.

# render error [fancy]

    Problem encountered while rendering template.
    [1mCaused by error:[22m
    [1m[22m[33m![39m Variable 'name' not found.
    [36mℹ[39m Error occurred on [32mline 1[39m and [32mcolumn 10[39m.

---

    Problem encountered while rendering template.
    [1mCaused by error:[22m
    [1m[22m[33m![39m Include 'missing.html' not found.
    [36mℹ[39m Error occurred on [32mline 1[39m and [32mcolumn 12[39m.

# JSON encoding error [plain]

    Problem encountered while decoding JSON data.
    i This is an internal error in the jinjar package, please report it to the package authors.
    Caused by error:
    ! [json.exception.parse_error.101] parse error at line 1, column 17: syntax error while parsing object - unexpected ']'; expected '}'
    i JSON object: "{\"name\": \"world\"]}"

# JSON encoding error [ansi]

    Problem encountered while decoding JSON data.
    [34mi[39m This is an internal error in the jinjar package, please report it to the package authors.
    [1mCaused by error:[22m
    [1m[22m[33m![39m [json.exception.parse_error.101] parse error at line 1, column 17: syntax error while parsing object - unexpected ']'; expected '}'
    [36mi[39m JSON object: [34m"{\"name\": \"world\"]}"[39m

# JSON encoding error [unicode]

    Problem encountered while decoding JSON data.
    ℹ This is an internal error in the jinjar package, please report it to the package authors.
    Caused by error:
    ! [json.exception.parse_error.101] parse error at line 1, column 17: syntax error while parsing object - unexpected ']'; expected '}'
    ℹ JSON object: "{\"name\": \"world\"]}"

# JSON encoding error [fancy]

    Problem encountered while decoding JSON data.
    [34mℹ[39m This is an internal error in the jinjar package, please report it to the package authors.
    [1mCaused by error:[22m
    [1m[22m[33m![39m [json.exception.parse_error.101] parse error at line 1, column 17: syntax error while parsing object - unexpected ']'; expected '}'
    [36mℹ[39m JSON object: [34m"{\"name\": \"world\"]}"[39m

