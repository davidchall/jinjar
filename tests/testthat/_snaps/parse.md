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

# print spans with overlap works [plain]

    Code
      print(x)
    Message
      {# {{ this }} is a {{ comment }} #}

# print spans with overlap works [ansi]

    Code
      print(x)
    Message
      [3m[90m{# {{ this }} is a {{ comment }} #}[39m[23m

# print spans with overlap works [unicode]

    Code
      print(x)
    Message
      {# {{ this }} is a {{ comment }} #}

# print spans with overlap works [fancy]

    Code
      print(x)
    Message
      [3m[90m{# {{ this }} is a {{ comment }} #}[39m[23m

# parse error [plain]

    Problem encountered while parsing template.
    Caused by error:
    ! Unexpected '}'.
    i Error occurred on line 1 and column 15.

# parse error [ansi]

    Problem encountered while parsing template.
    [1mCaused by error:[22m
    [1m[22m[33m![39m Unexpected '}'.
    [36mi[39m Error occurred on [32mline 1[39m and [32mcolumn 15[39m.

# parse error [unicode]

    Problem encountered while parsing template.
    Caused by error:
    ! Unexpected '}'.
    ℹ Error occurred on line 1 and column 15.

# parse error [fancy]

    Problem encountered while parsing template.
    [1mCaused by error:[22m
    [1m[22m[33m![39m Unexpected '}'.
    [36mℹ[39m Error occurred on [32mline 1[39m and [32mcolumn 15[39m.

