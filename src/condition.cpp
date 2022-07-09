#include <cpp11.hpp>
#include "condition.h"


void stop_inja(const std::string& type, const std::string& message, const size_t line, const size_t column) {
  auto stop_inja = cpp11::package("jinjar")["stop_inja"];
  stop_inja(type, message, line, column);
}

void stop_json(const std::string& message, const std::string& data_json) {
  auto stop_json = cpp11::package("jinjar")["stop_json"];
  stop_json(message, data_json);
}
