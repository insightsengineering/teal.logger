# teal.logger

<!-- start badges -->
[![Code Coverage](https://raw.githubusercontent.com/insightsengineering/teal.logger/_xml_coverage_reports/data/main/badge.svg)](https://raw.githubusercontent.com/insightsengineering/teal.logger/_xml_coverage_reports/data/main/coverage.xml)
<!-- end badges -->

`teal.logger` is an `R` package providing a unified setup for generating logs using the `logger` package.

## Installation

For releases from August 2022  it is recommended that you [create and use a Github PAT](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) to install the latest version of this package. Once you have the PAT, run the following:

```r
Sys.setenv(GITHUB_PAT = "your_access_token_here")
if (!require("remotes")) install.packages("remotes")
remotes::install_github("insightsengineering/teal.logger@*release")
```

A stable release of all `NEST` packages from June 2022 is also available [here](https://github.com/insightsengineering/depository#readme).

See package vignettes `browseVignettes(package = "teal.logger")` for usage of this package.

## Stargazers and Forkers

### Stargazers over time

[![Stargazers over time](https://starchart.cc/insightsengineering/teal.logger.svg)](https://starchart.cc/insightsengineering/teal.logger)

### Stargazers

[![Stargazers repo roster for @insightsengineering/teal.logger](https://reporoster.com/stars/insightsengineering/teal.logger)](https://github.com/insightsengineering/teal.logger/stargazers)

### Forkers

[![Forkers repo roster for @insightsengineering/teal.logger](https://reporoster.com/forks/insightsengineering/teal.logger)](https://github.com/insightsengineering/teal.logger/network/members)
