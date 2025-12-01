# Get value from environmental variable or R option or default in that order if the previous one is missing.

Get value from environmental variable or R option or default in that
order if the previous one is missing.

## Usage

``` r
get_val(env_var_name, option_name, default = NULL)
```

## Arguments

- env_var_name:

  (`character(1)`) name of the system variable

- option_name:

  (`character(1)`) name of the option

- default:

  optional, default value if both `Sys.getenv(env_var_name)` and
  `getOption(option_name)` are empty

## Value

an object of any class
