testthat::describe("log_shiny_input_changes", {
  it("validates all parameters correctly", {
    testthat::expect_error(
      log_shiny_input_changes(input = "not_reactivevalues"),
      regexp = "inherits.*reactivevalues"
    )

    shiny::withReactiveDomain(
      domain = shiny::MockShinySession$new(),
      {
        input <- shiny::reactiveValues(x = 1)

        testthat::expect_error(
          log_shiny_input_changes(input = input, namespace = c("a", "b")),
          regexp = "is.character.*length"
        )
        testthat::expect_error(
          log_shiny_input_changes(input = input, namespace = 123),
          regexp = "is.character"
        )
        testthat::expect_error(
          log_shiny_input_changes(input = input, excluded_inputs = 123),
          regexp = "is.character"
        )
        testthat::expect_error(
          log_shiny_input_changes(input = input, excluded_pattern = c("a", "b")),
          regexp = "is.character.*length"
        )
        testthat::expect_error(
          log_shiny_input_changes(input = input, excluded_pattern = 123),
          regexp = "is.character"
        )
        testthat::expect_error(
          log_shiny_input_changes(input = input, session = "not_session"),
          regexp = "inherits.*session"
        )
      }
    )
  })

  it("displays log in the shiny-module when its input changes and teal.log_level <= TRACE", {
    logged_messages <- character()
    log_appender_capture <- function(...) {
      args_list <- list(...)
      if (length(args_list) > 0) {
        msg <- args_list[[1]]
        logged_messages <<- c(logged_messages, as.character(msg))
      }
      invisible(NULL)
    }

    mod <- function(id) {
      shiny::moduleServer(id, function(input, output, session) {
        log_shiny_input_changes(input = input, namespace = "test")
      })
    }

    withr::with_options(list(teal.log_level = "TRACE"), {
      register_logger(namespace = "test")
      logger::log_appender(log_appender_capture, namespace = "test")

      shiny::testServer(
        mod,
        args = list(id = "test"),
        expr = {
          session$setInputs(test_input = 1)
          session$setInputs(test_input = 2)
        }
      )

      testthat::expect_true(length(logged_messages) > 0)
      testthat::expect_true(any(grepl("[TRACE]", logged_messages)))
      testthat::expect_true(any(grepl("Shiny input change detected in.*test_input", logged_messages)))
      testthat::expect_true(any(grepl("1 -> 2", logged_messages)))
    })
  })

  it("doesn't display log in shiny-module when its input changes and teal.log_level > TRACE", {
    logged_messages <- character()
    log_appender_capture <- function(...) {
      args_list <- list(...)
      if (length(args_list) > 0) {
        msg <- args_list[[1]]
        logged_messages <<- c(logged_messages, as.character(msg))
      }
      invisible(NULL)
    }

    mod <- function(id) {
      shiny::moduleServer(id, function(input, output, session) {
        log_shiny_input_changes(input = input, namespace = "test")
      })
    }

    withr::with_options(list(teal.log_level = "INFO"), {
      register_logger(namespace = "test")
      logger::log_appender(log_appender_capture, namespace = "test")

      shiny::testServer(
        mod,
        args = list(id = "test"),
        expr = {
          session$setInputs(test_input = 1)
          session$setInputs(test_input = 2)
        }
      )

      testthat::expect_length(logged_messages, 0)
    })
  })
})
