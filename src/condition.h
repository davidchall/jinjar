#ifndef __JINJAR_CONDITION__
#define __JINJAR_CONDITION__

#include <string>

void stop_inja(const std::string& type, const std::string& message, const size_t line, const size_t column);

void stop_json(const std::string& message, const std::string& data_json);

#endif
