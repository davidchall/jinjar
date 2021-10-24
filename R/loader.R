#' Template loaders
#'
#' Loaders are responsible for exposing templates to the templating engine.
#'
#' @return A `"jinjar_loader"` object.
#' @seealso The loader is an argument to [jinjar_config()].
#' @examples
#' path_loader(R.home())
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
  checkmate::assert_directory_exists(path)

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
  path_loader(fs::path_package(package, ...))
}

#' @export
print.path_loader <- function(x, ...) {
  cat("Path loader: ")
  print(x$path)
  invisible(x)
}

#' @description `list_loader()` loads templates from a named list.
#' @param x Named list mapping template names to template sources.
#' @rdname loader
#' @export
list_loader <- function(x) {
  checkmate::assert_list(x, types = "character", names = "unique", min.len = 1)
  do.call(new_loader, c(x, .class = "list_loader"))
}

#' @export
print.list_loader <- function(x, ...) {
  cat("List loader:", paste0("`", names(x), "`", collapse = ", "))
  invisible(x)
}
