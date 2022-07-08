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
    ! Include 'missing.html' not found.
    i Error occurred on line 1 and column 12.

# render error [ansi]

    Problem encountered while rendering template.
    [1mCaused by error:[22m
    [1m[22m[33m![39m Include 'missing.html' not found.
    [36mi[39m Error occurred on [32mline 1[39m and [32mcolumn 12[39m.

# render error [unicode]

    Problem encountered while rendering template.
    Caused by error:
    ! Include 'missing.html' not found.
    ℹ Error occurred on line 1 and column 12.

# render error [fancy]

    Problem encountered while rendering template.
    [1mCaused by error:[22m
    [1m[22m[33m![39m Include 'missing.html' not found.
    [36mℹ[39m Error occurred on [32mline 1[39m and [32mcolumn 12[39m.

