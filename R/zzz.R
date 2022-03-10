.onLoad <- function(libname, pkgname) { # nolint
  # Set up the teal logger instance
  register_logger("teal.logger")
  invisible()
}
