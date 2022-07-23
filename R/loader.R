#' Template loaders
#'
#' Loaders are responsible for exposing templates to the templating engine.
#'
#' @return A `"jinjar_loader"` object.
#' @seealso The loader is an argument to [jinjar_config()].
#' @examples
#' path_loader(getwd())
#'
#' package_loader("base", "demo")
#'
#' list_loader(list(
#'   header = "Title: {{ title }}",
#'   content = "Hello {{ person }}!"
#' ))
#' @name loader
NULL

new_loader <- function(..., .class = character()) {
  structure(list(...), class = c(.class, "jinjar_loader"))
}

#' @description `path_loader()` loads templates from a directory in the file system.
#' @param ... Strings specifying path components.
#' @rdname loader
#' @export
path_loader <- function(...) {
  path <- fs::path_abs(fs::path(...))
  check_dir_exists(path)

  new_loader(
    path = path,
    .class = "path_loader"
  )
}

#' @description `package_loader()` loads templates from a directory in an R package.
#' @param package Name of the package in which to search.
#' @rdname loader
#' @export
package_loader <- function(package, ...) {
  path <- fs::path_package(package, ...)
  check_dir_exists(path)

  new_loader(
    path = path,
    pkg = package,
    rel_path = fs::path(...),
    .class = c("package_loader", "path_loader")
  )
}

#' @export
print.path_loader <- function(x, ...) {
  cli::cli_text("{.strong Loader:} {.path {x$path}}")
  invisible(x)
}

#' @export
print.package_loader <- function(x, ...) {
  cli::cli_text("{.strong Loader:} {.pkg {{{x$pkg}}}}/{.path {x$rel_path}}")
  invisible(x)
}

#' @description `list_loader()` loads templates from a named list.
#' @param x Named list mapping template names to template sources.
#' @rdname loader
#' @export
list_loader <- function(x) {
  if (!(is_bare_list(x) && is_named(x))) {
    cli::cli_abort("{.arg x} must be a named list", arg = "x")
  }

  do.call(new_loader, c(x, .class = "list_loader"))
}

#' @export
print.list_loader <- function(x, ...) {
  csv_width <- sum(nchar(names(x)))

  if (csv_width <= 50) {
    cli::cli_text("{.strong Loader:} {.val {names(x)}}")
  } else {
    cli::cli_text("{.strong Loader:}")
    cli::cli_ul()
    for (name in names(x)) {
      cli::cli_li("{.val {name}}")
    }
    cli::cli_end()
  }

  invisible(x)
}
