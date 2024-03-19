#' Logs the basic information about the session.
#'
#' @return `invisible(NULL)`
#' @export
#'
log_system_info <- function() {
  paste_pkgs_name_with_version <- function(names) {
    vapply(
      names,
      FUN = function(name) paste(name, utils::packageVersion(name)),
      FUN.VALUE = character(1),
      USE.NAMES = FALSE
    )
  }

  info <- utils::sessionInfo()

  logger::log_trace("Platform: { info$platform }")
  logger::log_trace("Running under: { info$running }")
  logger::log_trace("{ info$R.version$version.string }")
  logger::log_trace("Base packages: { paste(info$basePkgs, collapse = ' ') }")

  # Paste package names and versions
  pasted_names_and_versions <- paste(paste_pkgs_name_with_version(names(info$otherPkgs)), collapse = ", ")
  logger::log_trace("Other attached packages: { pasted_names_and_versions }")

  pasted_names_and_versions <- paste(paste_pkgs_name_with_version(names(info$loadedOnly)), collapse = ", ")
  logger::log_trace("Loaded packages: { pasted_names_and_versions }")
}

#' Get value from environmental variable or R option or default in that order if the previous one is missing.
#' @param env_var_name (`character(1)`) name of the system variable
#' @param option_name (`character(1)`) name of the option
#' @param default optional, default value if both `Sys.getenv(env_var_name)` and `getOption(option_name)` are empty
#' @return an object of any class
#' keywords internal
get_val <- function(env_var_name, option_name, default = NULL) {
  value <- Sys.getenv(env_var_name)
  if (is.null(value) || value == "") value <- getOption(option_name, default = default)
  return(value)
}
