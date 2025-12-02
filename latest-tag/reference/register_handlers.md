# Register handlers for logging messages, warnings and errors

Register handlers for logging messages, warnings and errors

## Usage

``` r
register_handlers(namespace, package = namespace)
```

## Arguments

- namespace:

  (`character(1)`) the logger namespace

- package:

  (`character(1)`) the package name

## Value

`NULL` invisibly. Called for its side effects.

## Details

This function registers global handlers for messages, warnings and
errors. The handlers will investigate the call stack and if it contains
a function from the package, the message, warning or error will be
logged into the respective namespace.

The handlers are registered only once per package and type. Consecutive
calls will no effect. Registering handlers for package `base` is not
supported.

Use `TEAL.LOG_MUFFLE` environmental variable or `teal.log_muffle` R
option to optionally control recover strategies. If `TRUE` (a default
value) then the handler will jump to muffle restart for a given type of
condition and doesn't continue (with output to the console). Applicable
for message and warning types only. The errors won't be suppressed.

## Note

Registering handlers is forbidden within
[`tryCatch()`](https://rdrr.io/r/base/conditions.html) or
[`withCallingHandlers()`](https://rdrr.io/r/base/conditions.html).
Because of this, handlers are registered only if it is possible.

## See also

[`globalCallingHandlers()`](https://rdrr.io/r/base/conditions.html)

## Examples

``` r
if (FALSE) { # \dontrun{
register_handlers("teal.logger")
# see the outcome
globalCallingHandlers()
} # }
```
