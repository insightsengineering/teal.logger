# Teal `log_formatter`

Custom `log_formatter` supporting atomic vectors. By default
[`glue::glue`](https://glue.tidyverse.org/reference/glue.html) returns
n-element vector when vector is provided as an input. This function
generates `"[elem1, elem2, ...]"` for atomic vectors. Function also
handles `NULL` value which normally causes `logger` to return empty
character.

## Usage

``` r
teal_logger_formatter()

teal_logger_transformer(text, envir)
```

## Arguments

- text:

  Text (typically) R code to parse and evaluate.

- envir:

  environment to evaluate the code in

## Value

Nothing. Called for its side effects.
