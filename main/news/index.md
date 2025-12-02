# Changelog

## teal.logger 0.4.1.9000

## teal.logger 0.4.1

CRAN release: 2025-12-02

- Improved unit test and increased code coverage
  ([\#116](https://github.com/insightsengineering/teal.logger/issues/116)).
- Removed `lifecycle` dependency.

## teal.logger 0.4.0

CRAN release: 2025-07-08

- Update `logger` version to latest release.

## teal.logger 0.3.2

CRAN release: 2025-02-14

- Fixed a `glue` formatting issues when capturing errors, warnings or
  messages
  ([\#101](https://github.com/insightsengineering/teal.logger/issues/101)).

## teal.logger 0.3.1

CRAN release: 2025-01-22

- Enhance `log_shiny_input_changes` to support log levels provided in
  lowercase or numeric values.
- Fixed an issue with incorrect pasting of log messages when they were
  passed as vectors of length greater than one.

## teal.logger 0.3.0

CRAN release: 2024-10-24

- New function `log_shiny_input_changes` based on `logger`
  implementation, but curated to `teal` needs. It allows to track all
  shiny inputs changes in teal modules on `TRACE` level with appended
  namespace name.
- Fixed
  [`logger::formatter_glue`](https://daroczig.github.io/logger/reference/formatter_glue.html)
  to handle `NULL` and `vector` objects.

## teal.logger 0.2.0

CRAN release: 2024-03-24

- New function `register_handlers` to register global handlers for
  logging messages, warnings and errors.
- Specified minimal version of package dependencies.
- Update installation instructions in `README`.

## teal.logger 0.1.3

CRAN release: 2023-09-08

- Fixed CRAN requirements for the first CRAN submission.

## teal.logger 0.1.2

- Updated usage and installation instructions in `README`.
- Updated phrasing of the `Getting Started` vignette.

## teal.logger 0.1.1

- Updated installation instruction in `README`.

## teal.logger 0.1.0

- Initial release of `teal.logger`, a package for the logging setup for
  `teal` applications.

### Changes (from behavior when functionality was part of `teal`)

#### Misc

- The functions `suppress_logs` and `log_system_info` are now part of
  the API of the package as they are now exported.
