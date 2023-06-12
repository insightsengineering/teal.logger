# teal.logger

<!-- start badges -->
[![Check 🛠](https://github.com/insightsengineering/teal.logger/actions/workflows/check.yaml/badge.svg)](https://insightsengineering.github.io/teal.logger/main/unit-test-report/)
[![Docs 📚](https://github.com/insightsengineering/teal.logger/actions/workflows/docs.yaml/badge.svg)](https://insightsengineering.github.io/teal.logger/)
[![Code Coverage 📔](https://raw.githubusercontent.com/insightsengineering/teal.logger/_xml_coverage_reports/data/main/badge.svg)](https://insightsengineering.github.io/teal.logger/main/coverage-report/)

![GitHub forks](https://img.shields.io/github/forks/insightsengineering/teal.logger?style=social)
![GitHub repo stars](https://img.shields.io/github/stars/insightsengineering/teal.logger?style=social)

![GitHub commit activity](https://img.shields.io/github/commit-activity/m/insightsengineering/teal.logger)
![GitHub contributors](https://img.shields.io/github/contributors/insightsengineering/teal.logger)
![GitHub last commit](https://img.shields.io/github/last-commit/insightsengineering/teal.logger)
![GitHub pull requests](https://img.shields.io/github/issues-pr/insightsengineering/teal.logger)
![GitHub repo size](https://img.shields.io/github/repo-size/insightsengineering/teal.logger)
![GitHub language count](https://img.shields.io/github/languages/count/insightsengineering/teal.logger)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Current Version](https://img.shields.io/github/r-package/v/insightsengineering/teal.logger/main?color=purple\&label=package%20version)](https://github.com/insightsengineering/teal.logger/tree/main)
[![Open Issues](https://img.shields.io/github/issues-raw/insightsengineering/teal.logger?color=red\&label=open%20issues)](https://github.com/insightsengineering/teal.logger/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc)
<!-- end badges -->

`teal.logger` is an `R` package providing a unified setup for generating logs using the `logger` package.

## Installation

For releases from August 2022  it is recommended that you [create and use a GitHub PAT](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) to install the latest version of this package. Once you have the PAT, run the following:

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
