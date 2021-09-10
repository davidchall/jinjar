#ifndef __JINJAR_LOADER__
#define __JINJAR_LOADER__

#include <string>
#include <vector>
#include <cpp11/list.hpp>
namespace inja { class Environment; }


class Loader {
public:
  virtual ~Loader() {};
  virtual inja::Environment init_environment() = 0;
  static Loader* make_loader(const cpp11::list&);
};


class NullLoader : public Loader {
public:
  inja::Environment init_environment();
};


class PathLoader : public Loader {
private:
  std::string path;
public:
  PathLoader(const cpp11::list& loader);
  inja::Environment init_environment();
};


class ListLoader : public Loader {
private:
  std::vector<std::pair<std::string, std::string>> templates;
public:
  ListLoader(const cpp11::list& loader);
  inja::Environment init_environment();
};

#endif
