testthat::test_that("parse_logger_message correctly works on condition object", {
  testthat::expect_identical(parse_logger_message(simpleMessage("foo")), "foo")
  testthat::expect_identical(parse_logger_message(simpleWarning("foo")), "foo")
  testthat::expect_identical(parse_logger_message(simpleError("foo")), "foo")
})

testthat::test_that("parse_logger_message throws if not supported class of argument", {
  testthat::expect_error(parse_logger_message("foo"))
})

mocked_global_calling_handlers <- function(...) {
  # mocking base::globalCallingHandlers
  # we are interested whether setting a new value is requested, i.e. globalCallingHandlers() with a named argument
  # in particular: not a NULL value argument (i.e. clear) or not no argument (i.e. get)
  # see `?globalCallingHandlers` for more details
  x <- list(...)
  if (length(x) == 0) {
    # "return current handlers"
    return()
  } else {
    if (identical(x, list(NULL))) {
      # "clear handlers"
      return()
    } else {
      for (i in names(x)) {
        cat(sprintf("set handler for %s\n", i))
        return()
      }
    }
  }
}

testthat::test_that("register_handlers throws on incorrect namespace argument value", {
  testthat::with_mocked_bindings(
    code = {
      testthat::expect_error(register_handlers(1), "namespace argument")
      testthat::expect_error(register_handlers(NULL), "namespace argument")
      testthat::expect_error(register_handlers(NA_character_), "namespace argument")
    },
    register_handlers_possible = function() TRUE
  )
})

testthat::test_that("register_handlers throws if not pre-registered logger namespace", {
  testthat::with_mocked_bindings(
    testthat::expect_error(register_handlers("inexistent_namespace"), "pre-registered logger namespace"),
    register_handlers_possible = function() TRUE
  )
})

testthat::test_that("register_handlers throws on incorrect package argument value", {
  testthat::with_mocked_bindings(
    code = {
      register_logger("test")
      testthat::expect_error(register_handlers("test", 1), "package argument")
      testthat::expect_error(register_handlers("test", NULL), "package argument")
      testthat::expect_error(register_handlers("test", NA_character_), "package argument")
    },
    register_handlers_possible = function() TRUE
  )
})

testthat::test_that("register_handlers modifies global handlers", {
  testthat::with_mocked_bindings(
    testthat::with_mocked_bindings(
      code = {
        register_logger("test")
        testthat::expect_output(
          register_handlers(namespace = "test"),
          "set handler for message\nset handler for warning\nset handler for error"
        )
      },
      register_handlers_possible = function() TRUE
    ),
    globalCallingHandlers = mocked_global_calling_handlers,
    .package = "base"
  )
})

testthat::test_that("register_handlers is not called when within a try block", {
  testthat::expect_false(try(register_handlers_possible()))
})
testthat::test_that("register_handlers is not called when within a withCallingHandlers block", {
  testthat::expect_false(withCallingHandlers(register_handlers_possible(), foo = identity))
})
