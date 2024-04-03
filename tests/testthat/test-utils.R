testthat::test_that("get_val correctly reads envvar", {
  withr::with_envvar(
    list(DUMMY_ENVVAR = "ENVVAR_VALUE"),
    testthat::expect_identical(get_val("DUMMY_ENVVAR", "dummy_option"), "ENVVAR_VALUE")
  )
})

testthat::test_that("get_val uses option if envvar is missing", {
  withr::with_options(
    list(dummy_option = "option_value"),
    testthat::expect_identical(get_val("DUMMY_ENVVAR", "dummy_option"), "option_value")
  )
})

testthat::test_that("get_val uses envvar if both envvar and option are available", {
  withr::with_envvar(
    list(DUMMY_ENVVAR = "ENVVAR_VALUE"),
    withr::with_options(
      list(dummy_option = "option_value"),
      testthat::expect_identical(get_val("DUMMY_ENVVAR", "dummy_option"), "ENVVAR_VALUE")
    )
  )
})

testthat::test_that("get_val uses the default if both envvar and option are missing", {
  testthat::expect_identical(get_val("DUMMY_ENVVAR", "dummy_option", "default_value"), "default_value")
})

testthat::test_that("get_val: default accepts different types of data", {
  testthat::expect_identical(get_val("foo", "foo", NULL), NULL)
  testthat::expect_identical(get_val("foo", "foo", 0L), 0L)
  testthat::expect_error(get_val("foo", "foo", stop()))
})
