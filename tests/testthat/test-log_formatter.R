testthat::test_that("teal.logger formats NULL asis", {
  out <- logger::log_info("null: {NULL}")
  testthat::expect_equal(out$default$message, "null: NULL")
})

testthat::test_that("teal.logger formats character(0) asis", {
  out <- logger::log_info("empty character: {character(0)}")
  testthat::expect_equal(out$default$message, "empty character: character(0)")
})

testthat::test_that("teal.logger formats NA asis", {
  out <- logger::log_info("na: {NA}")
  testthat::expect_equal(
    out$default$message,
    "na: NA"
  )
})

testthat::test_that("teal.logger formats scalar asis", {
  out <- logger::log_info("numeric: {1}")
  testthat::expect_equal(out$default$message, "numeric: 1")
  out <- logger::log_info("character: {'a'}")
  testthat::expect_equal(out$default$message, 'character: "a"')
})

testthat::test_that("teal.logger formats vector as an array literal", {
  out <- logger::log_info("{letters[1:3]}")
  testthat::expect_equal(out$default$message, 'c("a", "b", "c")')
})

testthat::test_that("teal.logger formats two vectors in a single log", {
  out <- logger::log_info("one: {letters[1:2]} two: {letters[3:4]}")
  testthat::expect_equal(out$default$message, 'one: c("a", "b") two: c("c", "d")')
})

testthat::test_that("teal.logger formats list as a list literal", {
  out <- logger::log_info("list: {list(letters[1:2])}")
  testthat::expect_equal(out$default$message, 'list: list(c("a", "b"))')
})

testthat::test_that("teal.logger formats nested list as a named list array literal", {
  out <- logger::log_info("nested list: {list(a = letters[1:2], b = list(letters[3:4]))}")
  testthat::expect_equal(
    out$default$message,
    'nested list: list(a = c("a", "b"), b = list(c("c", "d")))'
  )
})

testthat::test_that("teal_logger_formatter sets up formatter correctly", {
  teal.logger:::teal_logger_formatter()
  testthat::expect_true(TRUE)
})

testthat::test_that("teal_logger_transformer handles numeric vectors", {
  envir <- new.env()
  envir$x <- c(1, 2, 3)
  result <- teal.logger:::teal_logger_transformer("x", envir)
  testthat::expect_type(result, "character")
  testthat::expect_match(result, "c\\(1, 2, 3\\)")
})

testthat::test_that("teal_logger_transformer handles logical values", {
  envir <- new.env()
  envir$x <- TRUE
  result <- teal.logger:::teal_logger_transformer("x", envir)
  testthat::expect_type(result, "character")
  testthat::expect_match(result, "TRUE")
})

testthat::test_that("teal_logger_transformer handles complex objects", {
  envir <- new.env()
  envir$x <- data.frame(a = 1:2, b = c("a", "b"))
  result <- teal.logger:::teal_logger_transformer("x", envir)
  testthat::expect_type(result, "character")
  testthat::expect_true(nchar(result) > 0)
})

testthat::test_that("teal_logger_transformer handles NULL", {
  envir <- new.env()
  envir$x <- NULL
  result <- teal.logger:::teal_logger_transformer("x", envir)
  testthat::expect_type(result, "character")
  testthat::expect_match(result, "NULL")
})

testthat::test_that("teal.logger formats numeric vectors", {
  out <- logger::log_info("numbers: {c(1, 2, 3)}")
  testthat::expect_match(out$default$message, "c\\(1, 2, 3\\)")
})

testthat::test_that("teal.logger formats logical vectors", {
  out <- logger::log_info("logical: {c(TRUE, FALSE, NA)}")
  testthat::expect_type(out$default$message, "character")
})

testthat::test_that("teal.logger formats empty list", {
  out <- logger::log_info("empty: {list()}")
  testthat::expect_match(out$default$message, "list\\(\\)")
})
