# path_loader works [plain]

    Code
      print(x)
    Message
      Loader: '/path/to/templates'

# path_loader works [ansi]

    Code
      print(x)
    Message
      [1mLoader:[22m [34m/path/to/templates[39m

# path_loader works [unicode]

    Code
      print(x)
    Message
      Loader: '/path/to/templates'

# path_loader works [fancy]

    Code
      print(x)
    Message
      [1mLoader:[22m [34m/path/to/templates[39m

# package_loader works [plain]

    Code
      print(x)
    Message
      Loader: {jinjar}/'R'

# package_loader works [ansi]

    Code
      print(x)
    Message
      [1mLoader:[22m [34m{jinjar}[39m/[34mR[39m

# package_loader works [unicode]

    Code
      print(x)
    Message
      Loader: {jinjar}/'R'

# package_loader works [fancy]

    Code
      print(x)
    Message
      [1mLoader:[22m [34m{jinjar}[39m/[34mR[39m

# list_loader works [plain]

    Code
      print(list_loader(short_names))
    Message
      Loader: "x", "y", and "z"
    Code
      print(list_loader(long_names))
    Message
      Loader:
      * "here_is_a_very_long_template_name"
      * "and_one_more_just_for_good_luck"

# list_loader works [ansi]

    Code
      print(list_loader(short_names))
    Message
      [1mLoader:[22m [34m"x"[39m, [34m"y"[39m, and [34m"z"[39m
    Code
      print(list_loader(long_names))
    Message
      [1mLoader:[22m
      * [34m"here_is_a_very_long_template_name"[39m
      * [34m"and_one_more_just_for_good_luck"[39m

# list_loader works [unicode]

    Code
      print(list_loader(short_names))
    Message
      Loader: "x", "y", and "z"
    Code
      print(list_loader(long_names))
    Message
      Loader:
      • "here_is_a_very_long_template_name"
      • "and_one_more_just_for_good_luck"

# list_loader works [fancy]

    Code
      print(list_loader(short_names))
    Message
      [1mLoader:[22m [34m"x"[39m, [34m"y"[39m, and [34m"z"[39m
    Code
      print(list_loader(long_names))
    Message
      [1mLoader:[22m
      • [34m"here_is_a_very_long_template_name"[39m
      • [34m"and_one_more_just_for_good_luck"[39m

