#include <cpp11.hpp>
#include "condition.h"


void stop_inja(const std::string& type, const std::string& message, const size_t line, const size_t column) {
  auto stop_inja = cpp11::package("jinjar")["stop_inja"];
  stop_inja(type, message, line, column);
}

void stop_json(const std::string& type, int id, const std::string& message) {
  // example message value:
  // [json.exception.type_error.302] (/x) type must be string, but is number
  std::string what = message.substr(message.find("]") + 2);
  std::string variable = "";

  if (what.substr(0, 2) == "(/") {
    what = what.substr(2);
    variable = what.substr(0, what.find_first_of("/)"));
    what = what.substr(what.find(")") + 2);
  }

  auto stop_json = cpp11::package("jinjar")["stop_json"];
  stop_json(type, id, what, variable);
}
