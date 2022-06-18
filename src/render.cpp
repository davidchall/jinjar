#include <cpp11.hpp>
#include "template.h"


[[cpp11::register]]
cpp11::external_pointer<jinjar::Template> parse_(const cpp11::strings& input,
                                                 const cpp11::list& config) {

  auto p_tmpl = new jinjar::Template(input, config);

  return cpp11::external_pointer<jinjar::Template>(p_tmpl);
}

[[cpp11::register]]
cpp11::strings render_(cpp11::external_pointer<jinjar::Template> input,
                       const cpp11::strings& data_json) {

  return input->render(data_json);
}
