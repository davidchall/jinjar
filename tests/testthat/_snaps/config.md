# input validation works

    Conflicting delimiters: `variable_open` and `block_open`

# default works [plain]

    Code
      print(x)
    Message
      
      -- Template configuration ------------------------------------------------------
      
      -- Loader --
      
      Disabled
      
      -- Syntax --
      
      * {% block %}
      * {{ variable }}
      * {# comment #}

# default works [ansi]

    Code
      print(x)
    Message
      
      [36m--[39m [1mTemplate configuration[22m [36m------------------------------------------------------[39m
      
      -- [1m[1mLoader[1m[22m --
      
      Disabled
      
      -- [1m[1mSyntax[1m[22m --
      
      * [34m{% block %}[39m
      * [32m{{ variable }}[39m
      * [3m[38;5;246m{# comment #}[39m[23m

# default works [unicode]

    Code
      print(x)
    Message
      
      ── Template configuration ──────────────────────────────────────────────────────
      
      ── Loader ──
      
      Disabled
      
      ── Syntax ──
      
      • {% block %}
      • {{ variable }}
      • {# comment #}

# default works [fancy]

    Code
      print(x)
    Message
      
      [36m──[39m [1mTemplate configuration[22m [36m──────────────────────────────────────────────────────[39m
      
      ── [1m[1mLoader[1m[22m ──
      
      Disabled
      
      ── [1m[1mSyntax[1m[22m ──
      
      • [34m{% block %}[39m
      • [32m{{ variable }}[39m
      • [3m[38;5;246m{# comment #}[39m[23m

# string loader works [plain]

    Code
      print(x)
    Message
      
      -- Template configuration ------------------------------------------------------
      
      -- Loader --
      
      Search path: '/Users/davidhall'
      
      -- Syntax --
      
      * {% block %}
      * {{ variable }}
      * {# comment #}

# string loader works [ansi]

    Code
      print(x)
    Message
      
      [36m--[39m [1mTemplate configuration[22m [36m------------------------------------------------------[39m
      
      -- [1m[1mLoader[1m[22m --
      
      Search path: [34m/Users/davidhall[39m
      
      -- [1m[1mSyntax[1m[22m --
      
      * [34m{% block %}[39m
      * [32m{{ variable }}[39m
      * [3m[38;5;246m{# comment #}[39m[23m

# string loader works [unicode]

    Code
      print(x)
    Message
      
      ── Template configuration ──────────────────────────────────────────────────────
      
      ── Loader ──
      
      Search path: '/Users/davidhall'
      
      ── Syntax ──
      
      • {% block %}
      • {{ variable }}
      • {# comment #}

# string loader works [fancy]

    Code
      print(x)
    Message
      
      [36m──[39m [1mTemplate configuration[22m [36m──────────────────────────────────────────────────────[39m
      
      ── [1m[1mLoader[1m[22m ──
      
      Search path: [34m/Users/davidhall[39m
      
      ── [1m[1mSyntax[1m[22m ──
      
      • [34m{% block %}[39m
      • [32m{{ variable }}[39m
      • [3m[38;5;246m{# comment #}[39m[23m

