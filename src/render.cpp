#include <cpp11.hpp>
#include <inja.hpp>


inja::Environment init_environment(const cpp11::list& config) {
  if (!Rf_inherits(config, "rinja_engine_config")) {
    cpp11::stop("Found invalid engine config.");
  }

  bool disable_search = Rf_isNull(config["search_path"]);
  std::string search_path = disable_search ? "" : cpp11::as_cpp<std::string>(config["search_path"]);

  inja::Environment env(search_path);
  if (disable_search) {
    env.set_search_included_templates_in_files(false);
  }

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

  return env;
}


[[cpp11::register]]
cpp11::strings c_render(const cpp11::strings& input,
                        const cpp11::strings& data_json,
                        const cpp11::list& config) {

  inja::Environment env = init_environment(config);

  auto data = nlohmann::json::parse(
    cpp11::as_cpp<std::string>(data_json)
  );

  std::string result = env.render(
    cpp11::as_cpp<std::string>(input),
    data
  );

  cpp11::writable::strings output;
  output.push_back(result);
  return output;
}
