# teal.logger 0.4.2
* Fix in vignette

# teal.logger 0.4.1.9002

# teal.logger 0.4.1

* Improved unit test and increased code coverage (#116).
* Removed `lifecycle` dependency.

# teal.logger 0.4.0

* Update `logger` version to latest release.

# teal.logger 0.3.2

* Fixed a `glue` formatting issues when capturing errors, warnings or messages (#101).

# teal.logger 0.3.1

* Enhance `log_shiny_input_changes` to support log levels provided in lowercase or numeric values.
* Fixed an issue with incorrect pasting of log messages when they were passed as vectors of length greater than one.

# teal.logger 0.3.0

* New function `log_shiny_input_changes` based on `logger` implementation, but curated to `teal` needs.
It allows to track all shiny inputs changes in teal modules on `TRACE` level with appended namespace name.
* Fixed `logger::formatter_glue` to handle `NULL` and `vector` objects.

# teal.logger 0.2.0

* New function `register_handlers` to register global handlers for logging messages, warnings and errors.
* Specified minimal version of package dependencies.
* Update installation instructions in `README`.

# teal.logger 0.1.3

* Fixed CRAN requirements for the first CRAN submission.

# teal.logger 0.1.2

* Updated usage and installation instructions in `README`.
* Updated phrasing of the `Getting Started` vignette.

# teal.logger 0.1.1

* Updated installation instruction in `README`.

# teal.logger 0.1.0

* Initial release of `teal.logger`, a package for the logging setup for `teal` applications.

## Changes (from behavior when functionality was part of `teal`)

### Misc
* The functions `suppress_logs` and `log_system_info` are now part of the API of the package as they are now exported.
