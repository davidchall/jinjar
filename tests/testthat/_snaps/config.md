# input validation works

    Code
      jinjar_config(block_open = "{{", variable_open = "{{")
    Condition
      Error in `jinjar_config()`:
      ! Conflicting delimiters: `variable_open` and `block_open`

# default works [plain]

    Code
      print(x)
    Message
      
      -- Template configuration ------------------------------------------------------
      Loader: disabled
      Syntax: {% block %} {{ variable }} {# comment #}

# default works [ansi]

    Code
      print(x)
    Message
      
      [36m--[39m [1mTemplate configuration[22m [36m------------------------------------------------------[39m
      [1mLoader:[22m disabled
      [1mSyntax:[22m [34m{% block %}[39m [32m{{ variable }}[39m [3m[90m{# comment #}[39m[23m

# default works [unicode]

    Code
      print(x)
    Message
      
      ── Template configuration ──────────────────────────────────────────────────────
      Loader: disabled
      Syntax: {% block %} {{ variable }} {# comment #}

# default works [fancy]

    Code
      print(x)
    Message
      
      [36m──[39m [1mTemplate configuration[22m [36m──────────────────────────────────────────────────────[39m
      [1mLoader:[22m disabled
      [1mSyntax:[22m [34m{% block %}[39m [32m{{ variable }}[39m [3m[90m{# comment #}[39m[23m

# string loader works [plain]

    Code
      print(x)
    Message
      
      -- Template configuration ------------------------------------------------------
      Loader: '/path/to/templates'
      Syntax: {% block %} {{ variable }} {# comment #}

# string loader works [ansi]

    Code
      print(x)
    Message
      
      [36m--[39m [1mTemplate configuration[22m [36m------------------------------------------------------[39m
      [1mLoader:[22m [34m/path/to/templates[39m
      [1mSyntax:[22m [34m{% block %}[39m [32m{{ variable }}[39m [3m[90m{# comment #}[39m[23m

# string loader works [unicode]

    Code
      print(x)
    Message
      
      ── Template configuration ──────────────────────────────────────────────────────
      Loader: '/path/to/templates'
      Syntax: {% block %} {{ variable }} {# comment #}

# string loader works [fancy]

    Code
      print(x)
    Message
      
      [36m──[39m [1mTemplate configuration[22m [36m──────────────────────────────────────────────────────[39m
      [1mLoader:[22m [34m/path/to/templates[39m
      [1mSyntax:[22m [34m{% block %}[39m [32m{{ variable }}[39m [3m[90m{# comment #}[39m[23m

