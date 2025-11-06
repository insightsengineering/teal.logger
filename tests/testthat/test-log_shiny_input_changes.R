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
    shiny::withReactiveDomain(
      domain = shiny::MockShinySession$new(),
      {
        input <- shiny::reactiveValues(x = 1, y = 2)
        logged_messages <- character()

        testthat::with_mocked_bindings(
          log_trace = function(msg, namespace = NA_character_, ...) {
            logged_messages <<- c(logged_messages, msg)
            invisible(NULL)
          },
          .package = "logger",
          code = {
            withr::with_options(list(teal.log_level = "TRACE"), {
              log_shiny_input_changes(input = input)
              # Simulate input change
              input$x <- 10
              input$y <- 20
              # Trigger reactive flush using internal function
              shiny:::flushReact()
            })
          }
        )

        testthat::expect_true(length(logged_messages) > 0)
        testthat::expect_true(any(grepl("Shiny input change", logged_messages)))
      }
    )
  })

  it("doesn't display log in shiny-module when its input changes and teal.log_level > TRACE", {
    shiny::withReactiveDomain(
      domain = shiny::MockShinySession$new(),
      {
        input <- shiny::reactiveValues(x = 1, y = 2)
        logged_messages <- character()

        testthat::with_mocked_bindings(
          log_trace = function(msg, namespace = NA_character_, ...) {
            logged_messages <<- c(logged_messages, msg)
            invisible(NULL)
          },
          .package = "logger",
          code = {
            withr::with_options(list(teal.log_level = "INFO"), {
              log_shiny_input_changes(input = input)
              # Simulate input change
              input$x <- 10
              input$y <- 20
              # Trigger reactive flush using internal function
              shiny:::flushReact()
            })
          }
        )

        testthat::expect_length(logged_messages, 0)
      }
    )
  })
})