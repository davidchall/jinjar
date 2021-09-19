#include "config.h"
#include "loader.h"
#include <cpp11.hpp>
#include <inja.hpp>


inja::Environment setup_environment(const cpp11::list& config) {
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

  return env;
}
