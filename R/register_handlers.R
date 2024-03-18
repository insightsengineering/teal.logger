#' Register handlers for logging messages, warnings and errors
#'
#' @param namespace (`character(1)`) the logger namespace
#' @param package (`character(1)`) the package name
#'
#' @return `NULL` invisibly. Called for its side effects.
#'
#' @details This function registers global handlers for messages, warnings and errors.
#' The handlers will investigate the call stack and if it contains a function
#' from the package, the message, warning or error will be logged into the respective
#' namespace.
#' The handlers are registered only once per package and type. Consecutive calls will be ignored.
#'
#' @note Registering handlers is forbidden within `tryCatch()` or `withCallingHandlers()`, e.g.
#' `try(globalCallingHandlers(NULL))` will throw an error.
#' Because of this, handlers are registered conditionally - only if it is possible.
#'
#' @seealso [globalCallingHandlers()]
#'
#' @export
#'
#' @examples
#' \dontrun{
#' register_handlers("teal.logger")
#' # see the outcome
#' globalCallingHandlers()
#' }
register_handlers <- function(namespace, package = namespace) {
  if (register_handlers_possible()) {
    register_handler_type(namespace = namespace, package = package, type = "message")
    register_handler_type(namespace = namespace, package = package, type = "warning")
    register_handler_type(namespace = namespace, package = package, type = "error")
  }

  invisible(NULL)
}

register_handler_type <- function(
    namespace,
    package,
    type = c("error", "warning", "message")) {
  match.arg(type)
  if (!(is.character(namespace) && length(namespace) == 1)) {
    stop("namespace argument must be a single string.")
  }
  if (!(namespace %in% logger::log_namespaces())) {
    stop("namespace argument must be a pre-registered logger namespace.")
  }
  if (!(is.character(package) && length(package) == 1)) {
    stop("package argument must be a single string.")
  }

  logger_fun <- switch(type,
    error = logger::log_error,
    warning = logger::log_warn,
    message = logger::log_info
  )

  # avoid re-registering the same handler
  gch <- globalCallingHandlers()[names(globalCallingHandlers()) == type]
  if (
    length(gch) > 0 &&
      any(sapply(gch, attr, "type") == "teal.logger_handler" & sapply(gch, attr, "package") == package)
  ) {
    return(invisible(NULL))
  }

  # create a handler object
  # loop through the call stack and if a function from a given package is found - log the message to the namespace
  handler_fun <- function(m) {
    i <- 0L
    while (i <= sys.nframe()) {
      if (isNamespaceLoaded(package) && identical(environment(sys.function(i)), getNamespace(package))) {
        msg <- m$message
        if (type %in% c("error", "warning") && !is.null(m$call)) {
          msg <- sprintf("In %s: %s", sQuote(paste0(format(m$call), collapse = "")), msg)
        }
        logger_fun(msg, namespace = namespace)
        break
      }
      i <- i + 1L
    }
  }
  # add attributes to enable checking if the handler is already registered
  handler_obj <- structure(
    handler_fun,
    type = "teal.logger_handler",
    package = package
  )

  # parse & eval the call - globalCallingHandlers() requires named arguments
  do.call(
    globalCallingHandlers,
    stats::setNames(list(handler_obj), type)
  )

  invisible(NULL)
}

#' Checks if it is possible to register handlers.
#'
#' @keywords internal
#'
#' @returns boolean
#' @examples
#' register_handlers_possible() # TRUE
#' try(register_handlers_possible()) # FALSE
#' withCallingHandlers(register_handlers_possible()) # FALSE
#'
#' \dontrun{
#' # To avoid errors when registering:
#' try(globalCallingHandlers(NULL))
#' withCallingHandlers(globalCallingHandlers(NULL), foo = identity)
#' }
register_handlers_possible <- function() {
  for (i in seq_len(sys.nframe())) {
    if (identical(sys.function(i), tryCatch) || identical(sys.function(i), withCallingHandlers)) {
      return(FALSE)
    }
  }
  return(TRUE)
}
