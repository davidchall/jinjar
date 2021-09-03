#include <cpp11.hpp>
#include <inja.hpp>
#include "config.h"


[[cpp11::register]]
cpp11::strings c_render(const cpp11::strings& input,
                        const cpp11::strings& data_json,
                        const cpp11::list& config) {

  inja::Environment env = setup_environment(config);

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
