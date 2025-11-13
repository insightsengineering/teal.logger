#' Suppress logger logs
#'
#' This function suppresses `logger` when running tests via `testthat`.
#' To suppress logs for a single test, add this function
#' call within the `testthat::test_that` expression. To suppress logs for an entire
#' test file, call this function at the start of the file.
#'
#' @return `NULL` invisible
#' @export
#' @examplesIf require("logger") && require("testthat")
#' testthat::test_that("An example test", {
#'   suppress_logs()
#'   testthat::expect_true(TRUE)
#' })
#'
suppress_logs <- function() {
  old_log_appenders <- lapply(logger::log_namespaces(), function(ns) logger::log_appender(namespace = ns))
  old_log_namespaces <- logger::log_namespaces()
  logger::log_appender(logger::appender_file(nullfile()), namespace = logger::log_namespaces())
  withr::defer_parent(
    mapply(
      function(appender, namespace) {
        # Evaluate appender in logger namespace environment to ensure logger functions are available
        logger_env <- asNamespace("logger")
        appender_eval <- tryCatch(
          eval(appender, envir = logger_env),
          error = function(e) {
            # Fallback: try evaluating in current environment if logger_env doesn't work
            eval(appender)
          }
        )
        logger::log_appender(appender_eval, namespace)
      },
      old_log_appenders,
      old_log_namespaces
    )
  )
  invisible(NULL)
}
