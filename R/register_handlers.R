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
#' @note Registering handlers is disallowed within `tryCatch` blocks which is used throughout
#' base R and other packages. Because of this, the `register_handlers` function is wrapped in a
#' `try` block to avoid errors.
#'
#' @seealso [globalCallingHandlers()]
#'
#' @export
#'
#' @examples
#' \dontrun{
#' register_logger(namespace = "teal.logger")
#' register_handlers("teal.logger")
#' # see the outcome
#' globalCallingHandlers()
#' }
register_handlers <- function(namespace, package = namespace) {
  try(
    {
      register_handler_message(namespace = namespace, package = package)
      register_handler_warning(namespace = namespace, package = package)
      register_handler_error(namespace = namespace, package = package)
    },
    silent = TRUE
  )

  invisible(NULL)
}

#' @keywords internal
register_handler_message <- function(namespace, package) {
  register_handler_type(namespace, package, "message")
}
#' @keywords internal
register_handler_warning <- function(namespace, package) {
  register_handler_type(namespace, package, "warning")
}
#' @keywords internal
register_handler_error <- function(namespace, package) {
  register_handler_type(namespace, package, "error")
}

#' @keywords internal
register_handler_type <- function(
    namespace,
    package,
    type = c("error", "warning", "message")) {
  match.arg(type)
  if (!(is.character(namespace) && length(namespace) == 1)) {
    stop("namespace argument must be a scalar character.")
  }
  if (!(namespace %in% logger::log_namespaces())) {
    stop("namespace argument must be a pre-registered logger namespace.")
  }
  if (!(is.character(package) && length(package) == 1)) {
    stop("package argument must be a scalar character.")
  }

  logger_fun <- switch(type,
    error = logger::log_error,
    warning = logger::log_warn,
    message = logger::log_info
  )

  # avoid re-registering the same handler
  gch <- globalCallingHandlers()[names(globalCallingHandlers()) == type]
  if (any(sapply(gch, attr, "type") == "teal.logger_handler" & sapply(gch, attr, "package") == package)) {
    return(invisible(NULL))
  }

  do.call(
    globalCallingHandlers,
    setNames(
      list(
        structure(
          function(m) {
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
          },
          type = "teal.logger_handler",
          package = package
        )
      ),
      type
    )
  )

  invisible(NULL)
}
