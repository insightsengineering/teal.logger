# teal.logger

`teal.logger` is an R package providing a unified setup for generating logs using the `logger` package. It is specifically designed for the `teal` family of packages and provides hierarchical logging, custom formatters, and shiny integration.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Bootstrap and Setup
Run these commands in order to set up the development environment:

```bash
# Install R and development dependencies
sudo apt-get update && sudo apt-get install -y r-base r-base-dev build-essential libcurl4-openssl-dev libssl-dev libxml2-dev

# Install R package development tools via apt (faster than CRAN)
sudo apt-get install -y r-cran-devtools r-cran-testthat r-cran-knitr r-cran-rmarkdown r-cran-remotes r-cran-withr r-cran-shiny r-cran-glue r-cran-logger r-cran-lintr

# Install the package for development
cd /path/to/teal.logger
sudo R -e "devtools::install()"
```

### Build and Test Commands
```bash
# Install package dependencies (runs quickly, ~10 seconds)
R -e "devtools::install_deps()"

# Install the package itself (~3 seconds, NEVER CANCEL)
sudo R -e "devtools::install()"

# Run linting (completes in ~2 seconds)
R -e "lintr::lint_package()"

# **WARNING**: R CMD check fails due to dependency version conflicts
# Do NOT use: devtools::check() - it requires logger >= 0.4.0 but Ubuntu has 0.2.2
# The package works despite this version conflict

# Test basic functionality (completes in < 1 second)
R -e "library(teal.logger); register_logger('test', 'INFO'); logger::log_info('Test message', namespace='test')"
```

### Validation Requirements
Always run this comprehensive validation after making changes to ensure functionality:

```r
# Run this complete validation scenario in R:
library(teal.logger)

# Test 1: Basic logger registration
register_logger(namespace = 'test1', level = 'INFO')
logger::log_info('Basic test', namespace = 'test1')

# Test 2: Different log levels
register_logger(namespace = 'test2', level = 'TRACE')
logger::log_trace('Trace message', namespace = 'test2')
logger::log_debug('Debug message', namespace = 'test2')
logger::log_info('Info message', namespace = 'test2')
logger::log_warn('Warning message', namespace = 'test2')
logger::log_error('Error message', namespace = 'test2')

# Test 3: Custom layout
register_logger(namespace = 'test3', level = 'INFO', layout = 'CUSTOM: {level} - {msg}')
logger::log_info('Custom layout test', namespace = 'test3')

# Test 4: Vector logging and formatting
register_logger(namespace = 'test4', level = 'INFO')
vec_data <- c('apple', 'banana', 'cherry')
logger::log_info('Vector: {vec_data}', namespace = 'test4')

# All tests should produce visible log output
```

## Key Limitations and Workarounds

### Known Issues
- **R CMD check fails**: Due to dependency version mismatch (logger >= 0.4.0 required, 0.2.2 available)
- **Documentation generation fails**: Cannot run `devtools::document()` due to same dependency issue
- **Some unit tests fail**: Package functions not loaded properly in test environment

### Working Commands
```bash
# ✅ These commands work reliably:
R -e "lintr::lint_package()"                    # Linting (2 seconds)
sudo R -e "devtools::install()"                 # Package installation (3 seconds)
R -e "library(teal.logger); [functionality]"    # Testing package features

# ❌ These commands fail due to dependency issues:
R -e "devtools::check()"                        # R CMD check - dependency version conflict
R -e "devtools::document()"                     # Documentation build - dependency conflict
R -e "testthat::test_dir('tests/testthat')"     # Unit tests - package loading issues
```

## CI/CD Integration

### GitHub Actions
The repository uses GitHub Actions workflows in `.github/workflows/`:
- `check.yaml` - R CMD check (will fail in our environment due to dependency versions)
- `docs.yaml` - Documentation building
- `release.yaml` - Release management

### Pre-commit Hooks
Pre-commit configuration is in `.pre-commit-config.yaml` with:
- Code styling with `styler`
- Documentation generation with `roxygenize`
- Spell checking
- Browser statement detection

Always run linting before committing:
```bash
R -e "lintr::lint_package()"
```

## Package Structure and Key Files

### Important Directories
```
R/                          # Main R source code
├── register_logger.R       # Core logging setup functions
├── register_handlers.R     # Global error/warning handlers
├── log_formatter.R         # Custom log formatters
├── log_shiny_input_changes.R # Shiny integration
└── utils.R                 # Utility functions

tests/testthat/             # Unit tests (note: some fail due to loading issues)
man/                        # Generated documentation
vignettes/                  # Package documentation
├── teal-logger.Rmd         # Getting started guide
```

### Configuration Files
- `.lintr` - Linting configuration (line length 120, specific exclusions)
- `DESCRIPTION` - Package metadata and dependencies
- `NAMESPACE` - Package exports (auto-generated)

## Development Workflow

### Making Changes
1. Edit R source files in `R/` directory
2. Run linting: `R -e "lintr::lint_package()"`
3. Install updated package: `sudo R -e "devtools::install()"`
4. Validate with comprehensive test scenario (see above)
5. Commit changes

### Key Functions to Understand
- `register_logger()` - Main function to set up logging for a namespace
- `register_handlers()` - Global handlers for errors/warnings
- `log_shiny_input_changes()` - Shiny-specific logging
- `teal_logger_formatter()` - Custom log formatting

### Dependencies
The package depends on:
- `logger` (>= 0.4.0) - Core logging functionality
- `glue` (>= 1.0.0) - String interpolation
- `shiny` (>= 1.6.0) - Shiny integration
- `withr` (>= 2.1.0) - Temporary state management
- `methods`, `utils` - Base R packages

## Common Tasks

### Testing Log Levels
```r
# Set different log levels
register_logger("myns", level = "TRACE")  # Most verbose
register_logger("myns", level = "DEBUG")
register_logger("myns", level = "INFO")   # Default
register_logger("myns", level = "WARN")
register_logger("myns", level = "ERROR")  # Least verbose
```

### Custom Log Layouts
```r
# Use custom layout format
register_logger(
  namespace = "myapp", 
  level = "INFO",
  layout = "[{level}] {time} {namespace}: {msg}"
)
```

### Environment Variables and Options
```r
# Control via environment variable
Sys.setenv(TEAL.LOG_LEVEL = "TRACE")

# Control via R option
options(teal.log_level = "DEBUG")
```

## Time Expectations
- **Package installation**: 3 seconds (NEVER CANCEL)
- **Linting**: 2 seconds
- **Functional testing**: < 1 second
- **Full validation scenario**: < 1 second

## Repository Context
This is part of the Insights Engineering `teal` ecosystem for clinical trial data analysis. The package provides standardized logging across all `teal` packages including `teal.modules.clinical`, `teal.transform`, etc.