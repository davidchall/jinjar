#include "loader.h"
#include <cpp11.hpp>
#include <inja.hpp>


// Loader factory ----------------------------------------------
Loader* Loader::make_loader(const cpp11::list& config) {
  if (Rf_isNull(config["loader"])) {
    return new NullLoader();
  }

  const cpp11::list loader = config["loader"];

  if (Rf_inherits(loader, "path_loader")) {
    return new PathLoader(loader);
  } else if (Rf_inherits(loader, "list_loader")) {
    return new ListLoader(loader);
  } else {
    cpp11::stop("Unrecognized loader object."); // # nocov
  }
}


// NullLoader ---------------------------------------------------
inja::Environment NullLoader::init_environment() {
  inja::Environment env;
  env.set_search_included_templates_in_files(false);
  return(env);
}


// PathLoader ---------------------------------------------------
PathLoader::PathLoader(const cpp11::list& loader) {
  path = cpp11::as_cpp<std::string>(loader["path"]);
}

inja::Environment PathLoader::init_environment() {
  return(inja::Environment(path));
}


// ListLoader ---------------------------------------------------
ListLoader::ListLoader(const cpp11::list& loader) {
  const cpp11::strings names = loader.names();
  for (auto it=names.begin(); it!=names.end(); ++it) {
    templates.push_back(std::make_pair(*it, cpp11::as_cpp<std::string>(loader[*it])));
  }
}

inja::Environment ListLoader::init_environment() {
  inja::Environment env;
  env.set_search_included_templates_in_files(false);

  for (auto it=templates.begin(); it!=templates.end(); ++it) {
    inja::Template x = env.parse(it->second);
    env.include_template(it->first, x);
  }

  return(env);
}
