testthat::test_that("parse_logger_message correctly works on condition object", {
  testthat::expect_identical(parse_logger_message(simpleMessage(message = "foo")), "foo")
  testthat::expect_identical(parse_logger_message(simpleWarning(message = "foo")), "foo")
  testthat::expect_identical(parse_logger_message(simpleError(message = "foo")), "foo")
})

testthat::test_that("parse_logger_message concatenates n-element message", {
  testthat::expect_identical(parse_logger_message(simpleMessage(message = c("foo1", "foo2"))), "foo1\nfoo2")
  testthat::expect_identical(parse_logger_message(simpleWarning(message = c("foo1", "foo2"))), "foo1\nfoo2")
  testthat::expect_identical(parse_logger_message(simpleError(message = c("foo1", "foo2"))), "foo1\nfoo2")
})

testthat::test_that("parse_logger_message includes call on warnings and errors", {
  testthat::expect_match(parse_logger_message(simpleWarning(message = "foo", call = "bar")), "In .bar.: foo")
  testthat::expect_match(parse_logger_message(simpleError(message = "foo", call = "bar")), "In .bar.: foo")
})

testthat::test_that("parse_logger_message throws if not supported class of argument", {
  testthat::expect_error(parse_logger_message("foo"))
})

mocked_handlers_list <- list()
mocked_global_calling_handlers <- function(...) {
  # mocking base::globalCallingHandlers
  # we are interested whether setting a new value is requested, i.e. globalCallingHandlers() with a named argument
  # in particular: not a NULL value argument (i.e. clear) or not no argument (i.e. get)
  # see `?globalCallingHandlers` for more details
  x <- list(...)
  if (length(x) == 0) {
    # "return current handlers"
    return(mocked_handlers_list)
  } else {
    if (identical(x, list(NULL))) {
      # "clear handlers"
      mocked_handlers_list <<- list()
      return()
    } else {
      for (i in names(x)) {
        # add handler
        mocked_handlers_list <<- append(mocked_handlers_list, setNames(list(x[[i]]), i))
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
        mocked_global_calling_handlers(NULL) # clear handlers
        testthat::expect_silent(register_handlers(namespace = "test"))
        testthat::expect_length(mocked_global_calling_handlers(), 3)
        mocked_global_calling_handlers(NULL) # clear handlers
      },
      register_handlers_possible = function() TRUE
    ),
    globalCallingHandlers = mocked_global_calling_handlers,
    .package = "base"
  )
})

testthat::test_that("register_handlers has no effect if called multiple times", {
  testthat::with_mocked_bindings(
    testthat::with_mocked_bindings(
      code = {
        register_logger("test")
        mocked_global_calling_handlers(NULL) # clear handlers
        testthat::expect_silent(register_handlers(namespace = "test"))
        testthat::expect_silent(register_handlers(namespace = "test"))
        testthat::expect_length(mocked_global_calling_handlers(), 3)
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
