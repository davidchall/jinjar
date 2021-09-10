#ifndef __JINJAR_CONFIG__
#define __JINJAR_CONFIG__

#include <cpp11/list.hpp>
namespace inja { class Environment; }


inja::Environment setup_environment(const cpp11::list& config);

#endif
