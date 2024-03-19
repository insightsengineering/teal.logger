# create a mutable object (i.e. environment) to store the information of registered handlers
registered_handlers_namespaces <- new.env()

.onLoad <- function(libname, pkgname) { # nolint
  # Set up the teal logger instance
  register_logger("teal.logger")
  register_handlers("teal.logger")
  invisible()
}
