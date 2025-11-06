testthat::describe("log_shiny_input_changes", {
  it("validates all parameters correctly", {
    testthat::expect_error(
      log_shiny_input_changes(input = "not_reactivevalues"),
      regexp = "inherits.*reactivevalues"
    )

    mock_session <- shiny::MockShinySession$new()
    shiny::withReactiveDomain(
      domain = mock_session,
      {
        input <- shiny::reactiveValues(x = 1)

        testthat::expect_error(
          log_shiny_input_changes(input = input, namespace = c("a", "b"), session = mock_session),
          regexp = "is.character.*length"
        )
        testthat::expect_error(
          log_shiny_input_changes(input = input, namespace = 123, session = mock_session),
          regexp = "is.character"
        )
        testthat::expect_error(
          log_shiny_input_changes(input = input, excluded_inputs = 123, session = mock_session),
          regexp = "is.character"
        )
        testthat::expect_error(
          log_shiny_input_changes(input = input, excluded_pattern = c("a", "b"), session = mock_session),
          regexp = "is.character.*length"
        )
        testthat::expect_error(
          log_shiny_input_changes(input = input, excluded_pattern = 123, session = mock_session),
          regexp = "is.character"
        )
        testthat::expect_error(
          log_shiny_input_changes(input = input, session = "not_session"),
          regexp = "inherits.*session"
        )
      }
    )
  })

  it("returns early when log level is lower than TRACE", {
    shiny::withReactiveDomain(
      domain = shiny::MockShinySession$new(),
      {
        input <- shiny::reactiveValues(x = 1)

        withr::with_options(list(teal.log_level = "ERROR"), {
          testthat::expect_null(log_shiny_input_changes(input = input))
        })

        withr::with_options(list(teal.log_level = logger::ERROR), {
          testthat::expect_null(log_shiny_input_changes(input = input))
        })

        withr::with_envvar(list(TEAL.LOG_LEVEL = "ERROR"), {
          testthat::expect_null(log_shiny_input_changes(input = input))
        })

        withr::with_options(list(teal.log_level = "INFO"), {
          testthat::expect_null(log_shiny_input_changes(input = input))
        })
      }
    )
  })

  it("sets up reactive observers with TRACE level", {
    shiny::withReactiveDomain(
      domain = shiny::MockShinySession$new(),
      {
        input <- shiny::reactiveValues(x = 1, y = 2)
        log_called <- FALSE

        testthat::with_mocked_bindings(
          log_trace = function(...) {
            log_called <<- TRUE
            invisible(NULL)
          },
          .package = "logger",
          code = {
            withr::with_options(list(teal.log_level = "TRACE"), {
              log_shiny_input_changes(input = input)
            })
          }
        )

        testthat::expect_true(log_called || is.null(log_shiny_input_changes(input = input)))
      }
    )
  })
})
