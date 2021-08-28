#include <cpp11.hpp>
#include <inja.hpp>


std::string parse_string(const cpp11::strings& x) {
  if (x.size() != 1) {
    cpp11::stop("Input must be a string.");
  }
  return std::string(x[0]);
}


[[cpp11::register]]
cpp11::strings c_render(const cpp11::strings& input,
                        const cpp11::strings& data_json) {
  inja::Environment env;

  auto data = nlohmann::json::parse(parse_string(data_json));

  std::string result = env.render(parse_string(input), data);

  cpp11::writable::strings output;
  output.push_back(result);
  return output;
}
