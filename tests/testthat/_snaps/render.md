# include tag

    Code
      render(fs::path("foo"), name = "world", .config = path_config)
    Output
      [1] "Hello world!\n"

---

    Code
      render(src, name = "world", .config = list_config)
    Output
      [1] "Hello world!"

# extends tag

    Code
      render(fs::path("foo"), name = "world", .config = path_config)
    Output
      [1] "Hello world!\n"

---

    Code
      render(src, name = "world", .config = list_config)
    Output
      [1] "Hello world!"

