#include <cpp11.hpp>
#include <inja.hpp>
#include "config.h"


[[cpp11::register]]
cpp11::strings c_render(const cpp11::strings& input,
                        const cpp11::strings& data_json,
                        const cpp11::list& config) {

  inja::Environment env = setup_environment(config);

  env.add_callback("escape_html", 1, [](inja::Arguments& args) {
    std::string s = args.at(0)->get<std::string>();
    inja::replace_substring(s, "&", "&amp;");
    inja::replace_substring(s, "<", "&lt;");
    inja::replace_substring(s, ">", "&gt;");
    inja::replace_substring(s, "\"", "&quot;");
    return s;
  });

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
