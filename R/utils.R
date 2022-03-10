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
