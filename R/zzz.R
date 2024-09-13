# create an object to store the information of registered handlers
registered_handlers_namespaces <- new.env()

.onLoad <- function(libname, pkgname) { # nolint
  teal_logger_formatter()
  # Set up the teal logger instance
  register_logger("teal.logger")
  register_handlers("teal.logger")
  invisible()
}
