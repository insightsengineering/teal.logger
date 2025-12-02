# Generate log layout function using common variables available via glue syntax including shiny session token

Generate log layout function using common variables available via glue
syntax including shiny session token

## Usage

``` r
layout_teal_glue_generator(layout)
```

## Arguments

- layout:

  (`character(1)`)  
  the log layout. Alongside the standard logging variables provided by
  the `logging` package (e.g. `pid`) the `token` variable can be used
  which will write the last 8 characters of the shiny session token to
  the log.

## Value

function taking `level` and `msg` arguments - keeping the original call
creating the generator in the generator attribute that is returned when
calling log_layout for the currently used layout

## Details

this function behaves in the same way as
[`logger::layout_glue_generator()`](https://daroczig.github.io/logger/reference/layout_glue_generator.html)
but allows the shiny session token (last 8 chars) to be included in the
logging layout
