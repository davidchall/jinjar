#include <cpp11.hpp>
#include <inja.hpp>


inja::Environment init_environment(const cpp11::list& config) {
  if (!Rf_inherits(config, "rinja_engine_config")) {
    cpp11::stop("Found invalid engine config.");
  }

  bool disable_search = true;
  std::string search_path = "";
  if (!Rf_isNull(config["loader"]) && Rf_inherits(config["loader"], "path_loader")) {
    const cpp11::list loader = config["loader"];
    disable_search = false;
    search_path = cpp11::as_cpp<std::string>(loader["path"]);
  }

  inja::Environment env(search_path);
  if (disable_search) {
    env.set_search_included_templates_in_files(false);
  }

  if (!Rf_isNull(config["loader"]) && Rf_inherits(config["loader"], "list_loader")) {
    const cpp11::list loader = config["loader"];
    const cpp11::strings names = loader.names();
    for (auto it=names.begin(); it!=names.end(); ++it) {
      inja::Template tmp = env.parse(cpp11::as_cpp<std::string>(loader[*it]));
      env.include_template(*it, tmp);
    }
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
