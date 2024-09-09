#' Teal `log_formatter`
#'
#' Custom `log_formatter` supporting atomic vectors. By default `glue::glue`
#' returns n-element vector when vector is provided as an input. This function
#' generates `"[elem1, elem2, ...]"` for atomic vectors. Function also handles
#' `NULL` value which normally causes `logger` to return empty character.
#' @name teal_logger_formatter
#' @return Nothing. Called for its side effects.
#' @keywords internal
teal_logger_formatter <- function() {
  logger::log_formatter(
    function(..., .logcall = sys.call(), .topcall = sys.call(-1), .topenv = parent.frame()) {
      logger::formatter_glue(
        ...,
        .logcall = .logcall, .topcall = .topcall, .topenv = .topenv,
        .transformer = teal_logger_transformer
      )
    }
  )
}

#' @rdname teal_logger_formatter
#' @inheritParams glue::identity_transformer
teal_logger_transformer <- function(text, envir) {
  value <- glue::identity_transformer(text, envir)
  expr <- dput(value, file = nullfile())
  deparse1(expr)
}
