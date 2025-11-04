testthat::describe("teal.logger formatting via public API", {
  testthat::it("formats NULL asis", {
    out <- logger::log_info("null: {NULL}")
    testthat::expect_equal(out$default$message, "null: NULL")
  })

  testthat::it("formats character(0) asis", {
    out <- logger::log_info("empty character: {character(0)}")
    testthat::expect_equal(out$default$message, "empty character: character(0)")
  })

  testthat::it("formats NA asis", {
    out <- logger::log_info("na: {NA}")
    testthat::expect_equal(out$default$message, "na: NA")
  })

  testthat::it("formats numeric scalar asis", {
    out <- logger::log_info("numeric: {1}")
    testthat::expect_equal(out$default$message, "numeric: 1")
  })

  testthat::it("formats character scalar asis", {
    out <- logger::log_info("character: {'a'}")
    testthat::expect_equal(out$default$message, 'character: "a"')
  })

  testthat::it("formats vector as an array literal", {
    out <- logger::log_info("{letters[1:3]}")
    testthat::expect_equal(out$default$message, 'c("a", "b", "c")')
  })

  testthat::it("formats two vectors in a single log", {
    out <- logger::log_info("one: {letters[1:2]} two: {letters[3:4]}")
    testthat::expect_equal(out$default$message, 'one: c("a", "b") two: c("c", "d")')
  })

  testthat::it("formats list as a list literal", {
    out <- logger::log_info("list: {list(letters[1:2])}")
    testthat::expect_equal(out$default$message, 'list: list(c("a", "b"))')
  })

  testthat::it("formats nested list as a named list array literal", {
    out <- logger::log_info("nested list: {list(a = letters[1:2], b = list(letters[3:4]))}")
    testthat::expect_equal(
      out$default$message,
      'nested list: list(a = c("a", "b"), b = list(c("c", "d")))'
    )
  })

  testthat::it("formats numeric vectors", {
    out <- logger::log_info("numbers: {c(1, 2, 3)}")
    testthat::expect_match(out$default$message, "c\\(1, 2, 3\\)")
  })

  testthat::it("formats logical vectors", {
    out <- logger::log_info("logical: {c(TRUE, FALSE, NA)}")
    testthat::expect_type(out$default$message, "character")
  })

  testthat::it("formats empty list", {
    out <- logger::log_info("empty: {list()}")
    testthat::expect_match(out$default$message, "list\\(\\)")
  })

  testthat::it("formats integer vectors", {
    out <- logger::log_info("integers: {c(1L, 2L, 3L)}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_true(nchar(out$default$message) > 0)
  })

  testthat::it("formats double vectors", {
    out <- logger::log_info("doubles: {c(1.5, 2.5, 3.5)}")
    testthat::expect_match(out$default$message, "c\\(1.5, 2.5, 3.5\\)")
  })

  testthat::it("formats complex vectors", {
    out <- logger::log_info("complex: {c(1+1i, 2+2i)}")
    testthat::expect_type(out$default$message, "character")
  })

  testthat::it("formats raw vectors", {
    out <- logger::log_info("raw: {as.raw(1:3)}")
    testthat::expect_type(out$default$message, "character")
  })

  testthat::it("formats data.frame", {
    out <- logger::log_info("df: {data.frame(a = 1:2, b = c('x', 'y'))}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_true(nchar(out$default$message) > 0)
  })

  testthat::it("formats matrix", {
    out <- logger::log_info("matrix: {matrix(1:4, nrow = 2)}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_true(nchar(out$default$message) > 0)
  })

  testthat::it("formats array", {
    out <- logger::log_info("array: {array(1:8, dim = c(2, 2, 2))}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_true(nchar(out$default$message) > 0)
  })

  testthat::it("formats factor", {
    out <- logger::log_info("factor: {factor(c('a', 'b', 'a'))}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_true(nchar(out$default$message) > 0)
  })

  testthat::it("formats Date", {
    out <- logger::log_info("date: {as.Date('2023-01-01')}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_true(nchar(out$default$message) > 0)
  })

  testthat::it("formats POSIXct", {
    out <- logger::log_info("datetime: {as.POSIXct('2023-01-01 12:00:00')}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_true(nchar(out$default$message) > 0)
  })

  testthat::it("formats named list", {
    out <- logger::log_info("named: {list(a = 1, b = 2)}")
    testthat::expect_match(out$default$message, "list\\(a = 1, b = 2\\)")
  })

  testthat::it("formats list with multiple element types", {
    out <- logger::log_info("mixed: {list(a = 1, b = 'x', c = TRUE)}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_true(nchar(out$default$message) > 0)
  })

  testthat::it("formats deeply nested list", {
    out <- logger::log_info("deep: {list(a = list(b = list(c = 1)))}}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_true(nchar(out$default$message) > 0)
  })

  testthat::it("formats environment variable", {
    test_env <- new.env()
    test_env$x <- 42
    out <- logger::log_info("env: {x}", .topenv = test_env)
    testthat::expect_match(out$default$message, "42")
  })

  testthat::it("formats multiple variables in single message", {
    out <- logger::log_info("a: {1} b: {2} c: {3}")
    testthat::expect_match(out$default$message, "a: 1")
    testthat::expect_match(out$default$message, "b: 2")
    testthat::expect_match(out$default$message, "c: 3")
  })

  testthat::it("formats vector with NA values", {
    out <- logger::log_info("na_vec: {c(1, NA, 3)}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_match(out$default$message, "NA")
  })

  testthat::it("formats vector with Inf values", {
    out <- logger::log_info("inf_vec: {c(1, Inf, 3)}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_match(out$default$message, "Inf")
  })

  testthat::it("formats vector with NaN values", {
    out <- logger::log_info("nan_vec: {c(1, NaN, 3)}")
    testthat::expect_type(out$default$message, "character")
  })

  testthat::it("formats empty vector", {
    out <- logger::log_info("empty: {character(0)}")
    testthat::expect_match(out$default$message, "character\\(0\\)")
  })

  testthat::it("formats single element vector", {
    out <- logger::log_info("single: {c(42)}")
    testthat::expect_match(out$default$message, "42")
  })

  testthat::it("formats large vector", {
    out <- logger::log_info("large: {1:100}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_true(nchar(out$default$message) > 0)
  })

  testthat::it("formats list with NULL element", {
    out <- logger::log_info("with_null: {list(a = 1, b = NULL, c = 3)}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_match(out$default$message, "NULL")
  })

  testthat::it("formats S3 object", {
    obj <- structure(list(x = 1), class = "test_class")
    out <- logger::log_info("s3: {obj}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_true(nchar(out$default$message) > 0)
  })

  testthat::it("formats function", {
    test_fun <- function(x) x
    out <- logger::log_info("fun: {test_fun}")
    testthat::expect_type(out$default$message, "character")
    testthat::expect_true(nchar(out$default$message) > 0)
  })
})
