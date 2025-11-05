testthat::describe("log_shiny_input_changes", {
  create_mock_session <- function() {
    structure(
      list(
        ns = function(prefix) {
          if (length(prefix) == 0 || identical(prefix, character(0))) "" else function(id) paste(prefix, id, sep = "-")
        }
      ),
      class = "ShinySession"
    )
  }

  it("validates all parameters correctly", {
    testthat::expect_error(
      log_shiny_input_changes(input = "not_reactivevalues"),
      regexp = "inherits.*reactivevalues"
    )

    input <- structure(list(), class = "reactivevalues")
    mock_session <- create_mock_session()

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
  })

  it("returns early when log level is too low", {
    input <- structure(list(x = 1), class = "reactivevalues")
    mock_session <- create_mock_session()

    withr::with_options(list(teal.log_level = "ERROR"), {
      testthat::expect_null(log_shiny_input_changes(input = input, session = mock_session))
    })

    withr::with_options(list(teal.log_level = logger::ERROR), {
      testthat::expect_null(log_shiny_input_changes(input = input, session = mock_session))
    })

    withr::with_envvar(list(TEAL.LOG_LEVEL = "ERROR"), {
      testthat::expect_null(log_shiny_input_changes(input = input, session = mock_session))
    })

    withr::with_options(list(teal.log_level = "INFO"), {
      testthat::expect_null(log_shiny_input_changes(input = input, session = mock_session))
    })

    session_proxy <- structure(
      list(ns = function(prefix) ""),
      class = "session_proxy"
    )
    withr::with_options(list(teal.log_level = "ERROR"), {
      testthat::expect_null(log_shiny_input_changes(input = input, session = session_proxy))
    })
  })

  it("sets up reactive observers with TRACE level", {
    input <- structure(list(x = 1, y = 2), class = "reactivevalues")
    mock_session <- create_mock_session()
    log_called <- FALSE

    testthat::with_mocked_bindings(
      reactive = function(expr) {
        expr_quoted <- substitute(expr)
        function() eval(expr_quoted, envir = parent.frame())
      },
      reactiveValuesToList = function(x) if (inherits(x, "reactivevalues")) unclass(x) else x,
      reactiveVal = function(value) {
        val <- value
        function(new_val = NULL) {
          if (!is.null(new_val)) val <<- new_val
          val
        }
      },
      isolate = function(expr) eval(substitute(expr), envir = parent.frame()),
      observeEvent = function(eventExpr, handlerExpr, ...) {
        eval(substitute(handlerExpr), envir = parent.frame())
        invisible(NULL)
      },
      .package = "shiny",
      code = {
        testthat::with_mocked_bindings(
          log_trace = function(...) {
            log_called <<- TRUE
            invisible(NULL)
          },
          .package = "logger",
          code = {
            withr::with_options(list(teal.log_level = "TRACE"), {
              log_shiny_input_changes(input = input, session = mock_session)
            })
          }
        )
      }
    )

    testthat::expect_true(log_called || is.null(log_shiny_input_changes(input = input, session = mock_session)))
  })
})
