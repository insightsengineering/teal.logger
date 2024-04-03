#' Register handlers for logging messages, warnings and errors
#'
#' @param namespace (`character(1)`) the logger namespace
#' @param package (`character(1)`) the package name
#'
#' @return `NULL` invisibly. Called for its side effects.
#'
#' @details
#' This function registers global handlers for messages, warnings and errors.
#' The handlers will investigate the call stack and if it contains a function
#' from the package, the message, warning or error will be logged into the respective
#' namespace.
#'
#' The handlers are registered only once per package and type. Consecutive calls will no effect.
#' Registering handlers for package `base` is not supported.
#'
#' Use `TEAL.LOG_MUFFLE` environmental variable or `teal.log_muffle` R option to optionally
#' control recover strategies. If `TRUE` (a default value) then the handler will jump to muffle
#' restart for a given type of condition and doesn't continue (with output to the console).
#' Applicable for message and warning types only. The errors won't be suppressed.
#'
#' @note Registering handlers is forbidden within `tryCatch()` or `withCallingHandlers()`.
#' Because of this, handlers are registered only if it is possible.
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
    package = namespace,
    type = c("error", "warning", "message")) {
  if (!(is.character(namespace) && length(namespace) == 1 && !is.na(namespace))) {
    stop("namespace argument must be a single string.")
  }
  if (!(namespace %in% logger::log_namespaces())) {
    stop("namespace argument must be a pre-registered logger namespace.")
  }
  if (!(is.character(package) && length(package) == 1 && !is.na(package))) {
    stop("package argument must be a single string.")
  }
  match.arg(type)

  registered_handlers_namespaces[[package]] <- namespace

  # avoid re-registering handlers
  gch <- globalCallingHandlers()[names(globalCallingHandlers()) == type]
  if (length(gch) > 0 && any(sapply(gch, attr, "type") == "teal.logger_handler")) {
    return(invisible(NULL))
  }

  # create a handler object
  # loop through the call stack starting from the bottom (the last call)
  # if a function is from pre-registered package then log using pre-specified namespace
  logger_fun <- switch(type,
    error = logger::log_error,
    warning = logger::log_warn,
    message = logger::log_info
  )
  # nocov start
  handler_fun <- function(m) {
    i <- sys.nframe() - 1L # loop starting from the bottom of the stack and go up
    while (i > 0L) { # exclude 0L as this value will detect the current `handler_fun()` function
      env_sys_fun_i <- environment(sys.function(i))
      pkg_sys_fun_i <- if (!is.null(env_sys_fun_i)) { # primitive functions don't have environment
        methods::getPackageName(env_sys_fun_i)
      } else {
        ""
      }
      if (pkg_sys_fun_i %in% ls(envir = registered_handlers_namespaces)) {
        msg <- parse_logger_message(m)

        log_namespace <- registered_handlers_namespaces[[pkg_sys_fun_i]]
        logger_fun(msg, namespace = log_namespace)

        # muffle restart
        if (isTRUE(as.logical(get_val("TEAL.LOG_MUFFLE", "teal.log_muffle", TRUE)))) {
          if (type == "message") {
            invokeRestart("muffleMessage")
          }
          if (type == "warning") {
            invokeRestart("muffleWarning")
          }
        }

        break
      }
      i <- i - 1L
    }
    m
  }
  # nocov end
  # add attributes to enable checking if the handler is already registered
  handler_obj <- structure(
    handler_fun,
    type = "teal.logger_handler"
  )

  # construct & eval the call - globalCallingHandlers() requires named arguments
  do.call(
    globalCallingHandlers,
    stats::setNames(list(handler_obj), type)
  )

  invisible(NULL)
}

parse_logger_message <- function(m) {
  stopifnot(inherits(m, "condition"))

  type <- class(m)[2]
  msg <- m$message
  if (type %in% c("error", "warning") && !is.null(m$call)) {
    msg <- sprintf("In %s: %s", sQuote(paste0(format(m$call), collapse = "")), msg)
  }
  return(msg)
}

register_handlers_possible <- function() {
  for (i in seq_len(sys.nframe())) {
    if (identical(sys.function(i), tryCatch) || identical(sys.function(i), withCallingHandlers)) {
      return(FALSE)
    }
  }
  return(TRUE) # nocov: impossible to cover because testthat introduces it's own handlers and we want to return FALSE
}
