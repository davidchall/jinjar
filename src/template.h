#ifndef __JINJAR_TEMPLATE__
#define __JINJAR_TEMPLATE__

#include <cpp11/strings.hpp>
#include <cpp11/list.hpp>
#include <inja.hpp>


namespace jinjar {
class Template {
  inja::Environment env;
  inja::Template templ;

public:
  Template(const cpp11::strings& x, const cpp11::list& config);
  const cpp11::strings render(const cpp11::strings& data_json);

private:
  static inja::Environment setup_environment(const cpp11::list& config);
};
}

#endif
