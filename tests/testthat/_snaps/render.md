# printing parsed document works [plain]

    Code
      print(x, n = Inf)
    Message
      Humans of A New Hope
      {# put a comment here #}
      {% for person in people -%}
      {% if "A New Hope" in person.films and default(person.species, "Unknown") == "Human" -%}
      * {{ person.name }} ({{ person.homeworld }})
      {% endif -%}
      {% endfor -%}

---

    Code
      print(x, n = 5)
    Message
      Humans of A New Hope
      {# put a comment here #}
      {% for person in people -%}
      {% if "A New Hope" in person.films and default(person.species, "Unknown") == "Human" -%}
      * {{ person.name }} ({{ person.homeworld }})
      i ... with 2 more lines

# printing parsed document works [ansi]

    Code
      print(x, n = Inf)
    Message
      Humans of A New Hope
      [3m[90m{# put a comment here #}[39m[23m
      [34m{% for person in people -%}[39m
      [34m{% if "A New Hope" in person.films and default(person.species, "Unknown") == "Human" -%}[39m
      * [32m{{ person.name }}[39m ([32m{{ person.homeworld }}[39m)
      [34m{% endif -%}[39m
      [34m{% endfor -%}[39m

---

    Code
      print(x, n = 5)
    Message
      Humans of A New Hope
      [3m[90m{# put a comment here #}[39m[23m
      [34m{% for person in people -%}[39m
      [34m{% if "A New Hope" in person.films and default(person.species, "Unknown") == "Human" -%}[39m
      * [32m{{ person.name }}[39m ([32m{{ person.homeworld }}[39m)
      [36mi[39m [90m... with 2 more lines[39m

# printing parsed document works [unicode]

    Code
      print(x, n = Inf)
    Message
      Humans of A New Hope
      {# put a comment here #}
      {% for person in people -%}
      {% if "A New Hope" in person.films and default(person.species, "Unknown") == "Human" -%}
      * {{ person.name }} ({{ person.homeworld }})
      {% endif -%}
      {% endfor -%}

---

    Code
      print(x, n = 5)
    Message
      Humans of A New Hope
      {# put a comment here #}
      {% for person in people -%}
      {% if "A New Hope" in person.films and default(person.species, "Unknown") == "Human" -%}
      * {{ person.name }} ({{ person.homeworld }})
      ℹ … with 2 more lines

# printing parsed document works [fancy]

    Code
      print(x, n = Inf)
    Message
      Humans of A New Hope
      [3m[90m{# put a comment here #}[39m[23m
      [34m{% for person in people -%}[39m
      [34m{% if "A New Hope" in person.films and default(person.species, "Unknown") == "Human" -%}[39m
      * [32m{{ person.name }}[39m ([32m{{ person.homeworld }}[39m)
      [34m{% endif -%}[39m
      [34m{% endfor -%}[39m

---

    Code
      print(x, n = 5)
    Message
      Humans of A New Hope
      [3m[90m{# put a comment here #}[39m[23m
      [34m{% for person in people -%}[39m
      [34m{% if "A New Hope" in person.films and default(person.species, "Unknown") == "Human" -%}[39m
      * [32m{{ person.name }}[39m ([32m{{ person.homeworld }}[39m)
      [36mℹ[39m [90m… with 2 more lines[39m

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

