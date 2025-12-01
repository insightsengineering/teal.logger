# Suppress logger logs

This function suppresses `logger` when running tests via `testthat`. To
suppress logs for a single test, add this function call within the
[`testthat::test_that`](https://testthat.r-lib.org/reference/test_that.html)
expression. To suppress logs for an entire test file, call this function
at the start of the file.

## Usage

``` r
suppress_logs()
```

## Value

`NULL` invisible

## Examples

``` r
testthat::test_that("An example test", {
  suppress_logs()
  testthat::expect_true(TRUE)
})
#> Test passed with 1 success 🎊.
```
