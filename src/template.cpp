#include <cpp11.hpp>
#include "template.h"
#include "loader.h"


jinjar::Template::Template(const cpp11::strings& x, const cpp11::list& config): env(setup_environment(config)) {
  templ = env.parse(
    cpp11::as_cpp<std::string>(x)
  );
}

const cpp11::strings jinjar::Template::render(const cpp11::strings& data_json) {
  auto data = nlohmann::json::parse(
    cpp11::as_cpp<std::string>(data_json)
  );

  std::string result = env.render(templ, data);

  cpp11::writable::strings output;
  output.push_back(result);
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

  return env;
}