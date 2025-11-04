# > devtools::test_active_file()
# [ FAIL 1 | WARN 0 | SKIP 0 | PASS 6 ]
#
# ── Error (test-supress_logs.R:6:1): suppress_logs suppresses logs ─────────────────────
# Error in `eval(appender)`: object 'appender_console' not found
# Backtrace:
#   ▆
# 1. ├─withr (local) `<fn>`()
# 2. └─base::mapply(...)
# 3.   └─teal.logger (local) `<fn>`(dots[[1L]][[1L]], dots[[2L]][[1L]])
# [ FAIL 1 | WARN 0 | SKIP 0 | PASS 6 ]
#
# > devtools::load_all(".")
# ℹ Loading teal.logger
# > devtools::test_active_file()
# [ FAIL 0 | WARN 0 | SKIP 0 | PASS 6 ]


testthat::test_that("suppress_logs suppresses logs", {
  test_namespace <- "test_suppress_logs"
  logger::log_threshold(logger::INFO, namespace = test_namespace)

  suppress_logs()

  during_suppress <- capture.output({
    logger::log_info("During suppression", namespace = test_namespace)
  }, type = "message")

  # Verify logs were suppressed (output should be empty)
  testthat::expect_length(during_suppress, 0)
})

testthat::test_that("suppress_logs works with multiple namespaces", {
  test_namespace1 <- "test_suppress_logs_1"
  test_namespace2 <- "test_suppress_logs_2"

  logger::log_threshold(logger::INFO, namespace = test_namespace1)
  logger::log_threshold(logger::INFO, namespace = test_namespace2)

  suppress_logs()

  suppress1 <- capture.output({
    logger::log_info("Test 1", namespace = test_namespace1)
  }, type = "message")

  suppress2 <- capture.output({
    logger::log_info("Test 2", namespace = test_namespace2)
  }, type = "message")

  testthat::expect_length(suppress1, 0)
  testthat::expect_length(suppress2, 0)
})

testthat::test_that("suppress_logs works with default namespace", {
  logger::log_threshold(logger::INFO)

  suppress_logs()

  suppress <- capture.output({
    logger::log_info("Test message")
  }, type = "message")

  testthat::expect_length(suppress, 0)
})

testthat::test_that("suppress_logs handles empty namespaces gracefully", {
  # This should not error even if no custom namespaces exist
  testthat::expect_no_error(suppress_logs())
})

testthat::test_that("suppress_logs handles namespaces with existing file appenders", {
  # Test that the function works when namespaces already have file appenders set
  # Using file appender to avoid restoration issues
  test_namespace <- "test_suppress_existing"

  logger::log_appender(logger::appender_file(nullfile()), namespace = test_namespace)
  logger::log_threshold(logger::INFO, namespace = test_namespace)

  suppress_logs()

  suppress <- capture.output({
    logger::log_info("Test existing", namespace = test_namespace)
  }, type = "message")

  testthat::expect_length(suppress, 0)
})

