#include <cpp11.hpp>
#include "template.h"


[[cpp11::register]]
cpp11::strings c_render_string(const cpp11::strings& input,
                               const cpp11::strings& data_json,
                               const cpp11::list& config) {

  auto tmpl = jinjar::Template(input, config);
  return tmpl.render(data_json);
}
