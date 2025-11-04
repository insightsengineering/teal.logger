testthat::describe("log_shiny_input_changes", {
  testthat::it("validates all parameters correctly", {
    mock_session <- structure(
      list(
        ns = function(prefix) {
          if (length(prefix) == 0 || identical(prefix, character(0))) {
            ""
          } else {
            function(id) paste(prefix, id, sep = "-")
          }
        }
      ),
      class = "ShinySession"
    )
    
    testthat::expect_error(
      log_shiny_input_changes(input = "not_reactivevalues"),
      regexp = "inherits.*reactivevalues"
    )
    
    input <- structure(list(), class = "reactivevalues")
    
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

  testthat::it("returns early when log level is too low", {
    input <- structure(list(x = 1, y = "test"), class = "reactivevalues")
    mock_session <- structure(
      list(
        ns = function(prefix) {
          if (length(prefix) == 0 || identical(prefix, character(0))) {
            ""
          } else {
            function(id) paste(prefix, id, sep = "-")
          }
        }
      ),
      class = "ShinySession"
    )
    
    withr::with_options(
      list(teal.log_level = "ERROR"),
      {
        result <- log_shiny_input_changes(input = input, session = mock_session)
        testthat::expect_null(result)
      }
    )
    
    withr::with_options(
      list(teal.log_level = logger::ERROR),
      {
        result <- log_shiny_input_changes(input = input, session = mock_session)
        testthat::expect_null(result)
      }
    )
    
    withr::with_envvar(
      list(TEAL.LOG_LEVEL = "ERROR"),
      {
        result <- log_shiny_input_changes(input = input, session = mock_session)
        testthat::expect_null(result)
      }
    )
    
    withr::with_options(
      list(teal.log_level = "INFO"),
      {
        result <- log_shiny_input_changes(input = input, session = mock_session)
        testthat::expect_null(result)
      }
    )
    
    empty_input <- structure(list(), class = "reactivevalues")
    withr::with_options(
      list(teal.log_level = "ERROR"),
      {
        result <- log_shiny_input_changes(input = empty_input, session = mock_session)
        testthat::expect_null(result)
      }
    )
    
    session_proxy <- structure(
      list(ns = function(prefix) {
        if (length(prefix) == 0 || identical(prefix, character(0))) "" else function(id) paste(prefix, id, sep = "-")
      }),
      class = "session_proxy"
    )
    withr::with_options(
      list(teal.log_level = "ERROR"),
      {
        result <- log_shiny_input_changes(input = input, session = session_proxy)
        testthat::expect_null(result)
      }
    )
    
    withr::with_options(
      list(teal.log_level = "ERROR"),
      {
        result <- log_shiny_input_changes(
          input = input,
          namespace = NA_character_,
          excluded_inputs = c("x"),
          excluded_pattern = "^x$",
          session = mock_session
        )
        testthat::expect_null(result)
      }
    )
  })

  testthat::it("detects and logs input changes with filtering and configuration", {
    input <- structure(list(x = 1, y = 2, y_width = 3), class = "reactivevalues")
    mock_session <- structure(
      list(
        ns = function(prefix) {
          if (length(prefix) == 0 || identical(prefix, character(0))) {
            ""
          } else {
            function(id) paste(prefix, id, sep = "-")
          }
        }
      ),
      class = "ShinySession"
    )
    logged_messages <- character()
    logged_namespaces <- character()
    call_count <- 0
    
    testthat::with_mocked_bindings(
      reactive = function(expr) {
        expr_quoted <- substitute(expr)
        function() {
          call_count <<- call_count + 1
          if (call_count == 1) {
            list(x = 1, y = 2)
          } else {
            list(x = 10, y = 20)
          }
        }
      },
      reactiveValuesToList = function(x) {
        if (inherits(x, "reactivevalues")) unclass(x) else x
      },
      reactiveVal = function(value) {
        val <- value
        function(new_val = NULL) {
          if (!is.null(new_val)) val <<- new_val
          val
        }
      },
      isolate = function(expr) {
        eval(substitute(expr), envir = parent.frame())
      },
      observeEvent = function(eventExpr, handlerExpr, ...) {
        eval(substitute(handlerExpr), envir = parent.frame())
        call_count <<- call_count + 1
        eval(substitute(handlerExpr), envir = parent.frame())
        invisible(NULL)
      },
      .package = "shiny",
      code = {
        testthat::with_mocked_bindings(
          log_trace = function(msg, namespace = NA_character_, ...) {
            logged_messages <<- c(logged_messages, msg)
            logged_namespaces <<- c(logged_namespaces, namespace)
            invisible(NULL)
          },
          .package = "logger",
          code = {
            withr::with_options(
              list(teal.log_level = "TRACE"),
              {
                log_shiny_input_changes(
                  input = input,
                  excluded_pattern = "_width$",
                  session = mock_session
                )
                testthat::expect_true(length(logged_messages) >= 2)
                testthat::expect_true(all(grepl("Shiny input change", logged_messages)))
                
                logged_messages <<- character()
                logged_namespaces <<- character()
                call_count <<- 0
                log_shiny_input_changes(
                  input = input,
                  namespace = "test_namespace",
                  excluded_pattern = "_width$",
                  session = mock_session
                )
                testthat::expect_true(length(logged_messages) >= 2)
                if (length(logged_namespaces) > 0) {
                  testthat::expect_true(all(logged_namespaces == "test_namespace", na.rm = TRUE))
                }
                
                logged_messages <<- character()
                call_count <<- 0
                log_shiny_input_changes(
                  input = input,
                  excluded_inputs = c("x"),
                  session = mock_session
                )
                testthat::expect_true(length(logged_messages) >= 1)
              }
            )
          }
        )
      }
    )
  })

  testthat::it("handles no changes, multiple changes, and message formatting", {
    input <- structure(list(x = 1, y = 2), class = "reactivevalues")
    mock_session <- structure(
      list(
        ns = function(prefix) {
          if (length(prefix) == 0 || identical(prefix, character(0))) {
            ""
          } else {
            function(id) paste(prefix, id, sep = "-")
          }
        }
      ),
      class = "ShinySession"
    )
    log_calls <- 0
    
    testthat::with_mocked_bindings(
      reactive = function(expr) {
        expr_quoted <- substitute(expr)
        function() {
          eval(expr_quoted, envir = parent.frame())
        }
      },
      reactiveValuesToList = function(x) {
        if (inherits(x, "reactivevalues")) unclass(x) else x
      },
      reactiveVal = function(value) {
        val <- value
        function(new_val = NULL) {
          if (!is.null(new_val)) val <<- new_val
          val
        }
      },
      isolate = function(expr) {
        eval(substitute(expr), envir = parent.frame())
      },
      observeEvent = function(eventExpr, handlerExpr, ...) {
        eval(substitute(handlerExpr), envir = parent.frame())
        invisible(NULL)
      },
      .package = "shiny",
      code = {
        testthat::with_mocked_bindings(
          log_trace = function(msg, namespace = NA_character_, ...) {
            log_calls <<- log_calls + 1
            invisible(NULL)
          },
          .package = "logger",
          code = {
            withr::with_options(
              list(teal.log_level = "TRACE"),
              {
                log_shiny_input_changes(input = input, session = mock_session)
                testthat::expect_equal(log_calls, 0)
                
                call_count <- 0
                log_calls <<- 0
                testthat::with_mocked_bindings(
                  reactive = function(expr) {
                    expr_quoted <- substitute(expr)
                    function() {
                      call_count <<- call_count + 1
                      if (call_count == 1) {
                        list(x = 1, y = 2)
                      } else {
                        list(x = 10, y = 20)
                      }
                    }
                  },
                  observeEvent = function(eventExpr, handlerExpr, ...) {
                    eval(substitute(handlerExpr), envir = parent.frame())
                    call_count <<- call_count + 1
                    eval(substitute(handlerExpr), envir = parent.frame())
                    invisible(NULL)
                  },
                  .package = "shiny",
                  code = {
                    log_shiny_input_changes(input = input, session = mock_session)
                    testthat::expect_true(log_calls >= 2)
                  }
                )
              }
            )
          }
        )
      }
    )
  })
})