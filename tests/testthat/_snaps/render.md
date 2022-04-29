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

