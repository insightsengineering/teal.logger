# teal.logger

<!-- start badges -->

[![CRAN Version](https://www.r-pkg.org/badges/version/teal.logger?color=green)](https://cran.r-project.org/package=teal.logger)
[![Total Downloads](http://cranlogs.r-pkg.org/badges/grand-total/teal.logger?color=green)](https://cran.r-project.org/package=teal.logger)
[![Last Month Downloads](http://cranlogs.r-pkg.org/badges/last-month/teal.logger?color=green)](https://cran.r-project.org/package=teal.logger)
[![Last Week Downloads](http://cranlogs.r-pkg.org/badges/last-week/teal.logger?color=green)](https://cran.r-project.org/package=teal.logger)

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


```r
# stable versions
install.packages('teal.logger')

# install.packages("pak")
pak::pak("insightsengineering/teal.logger@*release")
```

Alternatively, you might want to use the development version available on [r-universe](https://r-universe.dev/).

```r
# beta versions
install.packages('teal.logger', repos = c('https://pharmaverse.r-universe.dev', 'https://cloud.r-project.org'))

# install.packages("pak")
pak::pak("insightsengineering/teal.logger")
```

## Usage

To understand how to use this package, please refer to the [Getting Started](https://insightsengineering.github.io/teal.logger/latest-tag/articles/teal-logger.html) article, which provides multiple examples of code implementation.

Below is the showcase of the example usage

```r
library(teal.logger)
register_logger(namespace = "namespace1", level = "INFO")
logger::log_info("Hello from namespace1", namespace = "namespace1")
logger::log_warn("Hello from namespace1", namespace = "namespace1")
logger::log_success("Hello from namespace1", namespace = "namespace1")
# [INFO] 2023-08-31 12:02:41.0678 pid:7128 token:[] namespace1 Hello from namespace1
# [WARN] 2023-08-31 12:02:42.4872 pid:7128 token:[] namespace1 Hello from namespace
# [SUCCESS] 2023-08-31 12:02:58.7155 pid:7128 token:[] namespace1 Hello from namespace

register_logger(namespace = "namespace2", level = "WARN")
logger::log_info("Hello from namespace2", namespace = "namespace2")
logger::log_warn("Hello from namespace2", namespace = "namespace2")
logger::log_error("Hello from namespace2", namespace = "namespace2")
# [WARN] 2023-08-31 12:04:34.9361 pid:7128 token:[] namespace2 Hello from namespace2
# [ERROR] 2023-08-31 12:04:35.5721 pid:7128 token:[] namespace2 Hello from namespace2
```

## Getting help

If you encounter a bug or you have a feature request - please file an issue. For questions, discussions and staying up to date, please use the "teal" channel in the [`pharmaverse` slack workspace](https://pharmaverse.slack.com).

## Stargazers and Forkers

### Stargazers over time

[![Stargazers over time](https://starchart.cc/insightsengineering/teal.logger.svg)](https://starchart.cc/insightsengineering/teal.logger)

### Stargazers

[![Stargazers repo roster for @insightsengineering/teal.logger](https://reporoster.com/stars/insightsengineering/teal.logger)](https://github.com/insightsengineering/teal.logger/stargazers)

### Forkers

[![Forkers repo roster for @insightsengineering/teal.logger](https://reporoster.com/forks/insightsengineering/teal.logger)](https://github.com/insightsengineering/teal.logger/network/members)
