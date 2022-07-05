# teal.logger

`teal.logger` is an `R` package providing a unified setup for generating logs using the `logger` package.

## Installation

It is recommended that you [create and use a Github PAT](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) to install the latest version of this package. Once you have the PAT, run the following:

```r
Sys.setenv(GITHUB_PAT = "your_access_token_here")
if (!require("remotes")) install.packages("remotes")
remotes::install_github("insightsengineering/teal.logger@*release")
```

A stable release of all `NEST` packages is also available [here](https://github.com/insightsengineering/depository#readme).

See package vignettes `browseVignettes(package = "teal.logger")` for usage of this package.
