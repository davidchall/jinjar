#include <cpp11.hpp>
#include "template.h"
#include "loader.h"
#include "condition.h"


jinjar::Template::Template(const cpp11::strings& x, const cpp11::list& config): env(setup_environment(config)) {
  try {
    auto txt = cpp11::as_cpp<std::string>(x);
    templ = env.parse(txt);
  } catch (const inja::InjaError& e) {
    stop_inja(e.type, e.message, e.location.line, e.location.column);
  }
}

const cpp11::strings jinjar::Template::render(const cpp11::strings& data_json) {
  auto data_json_str = cpp11::as_cpp<std::string>(data_json);
  cpp11::writable::strings output;

  try {
    auto data = nlohmann::json::parse(data_json_str);
    auto result = env.render(templ, data);
    output.push_back(result);
  } catch (const nlohmann::json::parse_error& e) {
    stop_json(e.what(), data_json_str);
  } catch (const inja::InjaError& e) {
    stop_inja(e.type, e.message, e.location.line, e.location.column);
  }

  return output;
}

inja::Environment jinjar::Template::setup_environment(const cpp11::list& config) {
  if (!Rf_inherits(config, "jinjar_config")) {
    cpp11::stop("Found invalid engine config."); // # nocov
  }

  Loader* loader = Loader::make_loader(config);
  inja::Environment env = loader->init_environment();
  delete loader;

  env.set_statement(
    cpp11::as_cpp<std::string>(config["block_open"]),
    cpp11::as_cpp<std::string>(config["block_close"])
  );
  env.set_line_statement(
    cpp11::as_cpp<std::string>(config["line_statement"])
  );
  env.set_expression(
    cpp11::as_cpp<std::string>(config["variable_open"]),
    cpp11::as_cpp<std::string>(config["variable_close"])
  );
  env.set_comment(
    cpp11::as_cpp<std::string>(config["comment_open"]),
    cpp11::as_cpp<std::string>(config["comment_close"])
  );
  env.set_trim_blocks(
    cpp11::as_cpp<bool>(config["trim_blocks"])
  );
  env.set_lstrip_blocks(
    cpp11::as_cpp<bool>(config["lstrip_blocks"])
  );
  env.set_throw_at_missing_includes(
    !cpp11::as_cpp<bool>(config["ignore_missing_files"])
  );

  env.add_callback("escape_html", 1, [](inja::Arguments& args) {
    std::string s = args.at(0)->get<std::string>();
    inja::replace_substring(s, "&", "&amp;");
    inja::replace_substring(s, "<", "&lt;");
    inja::replace_substring(s, ">", "&gt;");
    inja::replace_substring(s, "\"", "&quot;");
    return s;
  });

  env.add_callback("quote_sql", 1, [](inja::Arguments& args) {
    auto quote_sql = [](const nlohmann::json& x) {
      std::string out;
      if (x.is_string()) {
        out.push_back('\'');
        for (char c : x.get<std::string>()) {
          if (c == '\'') {
            // escape single-quote with additional single-quote
            out.push_back('\'');
          }
          out.push_back(c);
        }
        out.push_back('\'');
      } else if (x.is_null()) {
        out = "NULL";
      } else if (x.is_number()) {
        out = x.dump();
      } else if (x.is_boolean()) {
        out = x.get<bool>() ? "TRUE" : "FALSE";
      } else {
        std::string received = x.type_name();
        cpp11::stop("quote_sql() expects string, numeric or boolean but received " + received);
      }
      return out;
    };

    std::ostringstream os;
    const auto val = *args[0];

    if (val.is_array()) {
      std::string sep;
      for (const auto& x : val) {
        os << sep;
        os << quote_sql(x);
        sep = ", ";
      }
    } else {
      os << quote_sql(val);
    }

    return os.str();
  });

  return env;
}
