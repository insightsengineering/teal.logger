# Registers a logger instance in a given logging namespace.

Registers logger instance.

## Usage

``` r
register_logger(namespace = NA_character_, layout = NULL, level = NULL)
```

## Arguments

- namespace:

  (`character(1)` or `NA_character_`)  
  the name of the logging namespace

- layout:

  (`character(1)`)  
  the log layout. Alongside the standard logging variables provided by
  the `logging` package (e.g. `pid`) the `token` variable can be used
  which will write the last 8 characters of the shiny session token to
  the log.

- level:

  (`character(1)` or `call`) the log level. Can be passed as character
  or one of the `logger`'s objects. See
  [`logger::log_threshold()`](https://daroczig.github.io/logger/reference/log_threshold.html)
  for more information.

## Value

`invisible(NULL)`

## Details

Creates a new logging namespace specified by the `namespace` argument.
When the `layout` and `level` arguments are set to `NULL` (default), the
function gets the values for them from system variables or R options.
When deciding what to use (either argument, an R option or system
variable), the function picks the first non `NULL` value, checking in
order:

1.  Function argument.

2.  System variable.

3.  R option.

`layout` and `level` can be set as system environment variables,
respectively:

- `teal.log_layout` as `TEAL.LOG_LAYOUT`,

- `teal.log_level` as `TEAL.LOG_LEVEL`.

If neither the argument nor the environment variable is set the function
uses the following R options:

- `options(teal.log_layout)`, which is passed to
  [`logger::layout_glue_generator()`](https://daroczig.github.io/logger/reference/layout_glue_generator.html),

- `options(teal.log_level)`, which is passed to
  [`logger::log_threshold()`](https://daroczig.github.io/logger/reference/log_threshold.html)

The logs are output to `stdout` by default. Check `logger` for more
information about layouts and how to use `logger`.

## Note

It's a thin wrapper around the `logger` package.

## See also

The package vignettes for more help: `browseVignettes("teal.logger")`.

## Examples

``` r
options(teal.log_layout = "{msg}")
options(teal.log_level = "ERROR")
register_logger(namespace = "new_namespace")
# \donttest{
logger::log_info("Hello from new_namespace", namespace = "new_namespace")
# }
```
