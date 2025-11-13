testthat::describe("suppress_logs", {
  it("suppresses logs for a single namespace", {
    test_namespace <- "test_suppress_logs"
    logger::log_appender(logger::appender_file(nullfile()), namespace = test_namespace)
    logger::log_threshold(logger::INFO, namespace = test_namespace)

    suppress_logs()

    during_suppress <- capture.output(
      {
        logger::log_info("During suppression", namespace = test_namespace)
      },
      type = "message"
    )

    testthat::expect_length(during_suppress, 0)
  })

  it("suppresses logs for multiple namespaces", {
    test_namespace1 <- "test_suppress_logs_1"
    test_namespace2 <- "test_suppress_logs_2"

    logger::log_threshold(logger::INFO, namespace = test_namespace1)
    logger::log_threshold(logger::INFO, namespace = test_namespace2)

    suppress_logs()

    suppress1 <- capture.output(
      {
        logger::log_info("Test 1", namespace = test_namespace1)
      },
      type = "message"
    )

    suppress2 <- capture.output(
      {
        logger::log_info("Test 2", namespace = test_namespace2)
      },
      type = "message"
    )

    testthat::expect_length(suppress1, 0)
    testthat::expect_length(suppress2, 0)
  })

  it("suppresses logs for default namespace", {
    logger::log_appender(logger::appender_file(nullfile()))
    logger::log_threshold(logger::INFO)

    suppress_logs()

    suppress <- capture.output(
      {
        logger::log_info("Test message")
      },
      type = "message"
    )

    testthat::expect_length(suppress, 0)
  })

  it("handles empty namespaces gracefully", {
    testthat::expect_no_error(suppress_logs())
  })
})
