#' Auto logging input changes in Shiny app
#'
#' This is to be called in the \code{server} section of the Shiny app.
#'
#' Function taken from \pkg{logger} package and improved in this PR
#' [daroczig/logger/pull/155](https://github.com/daroczig/logger/pull/155/). Once this PR gets merged, the function will
#' be removed.
#'
#' @keywords internal
#'
#' @param input passed from Shiny's \code{server}
#' @param level log level
#' @param excluded_inputs character vector of input names to exclude from logging
#' @param excluded_patterns character of length one including a grep pattern of names to be excluded from logging
#' @param skip_init should initialization message be displayed
#' @param namespace the name of the namespace
#' @importFrom utils assignInMyNamespace assignInNamespace
#' @examples \dontrun{
#' library(shiny)
#'
#' ui <- bootstrapPage(
#'   numericInput("mean1", "mean1", 0),
#'   numericInput("mean2", "mean2", 0),
#'   numericInput("sd", "sd", 1),
#'   textInput("title", "title", "title"),
#'   textInput("foo", "This is not used at all, still gets logged", "foo"),
#'   passwordInput("password", "Password not to be logged", "secret"),
#'   plotOutput("plot")
#' )
#'
#' server <- function(input, output) {
#'   log_shiny_input_changes(input, excluded_inputs = "password", exclude_patterns = "mean")
#'
#'   output$plot <- renderPlot({
#'     hist(rnorm(1e3, input$mean, input$sd), main = input$title)
#'   })
#' }
#'
#' shinyApp(ui = ui, server = server)
#' }
log_shiny_input_changes <- function(
    input,
    level = logger::INFO,
    namespace = NA_character_,
    excluded_inputs = character(),
    excluded_patterns = character(),
    skip_init = FALSE) {
  session <- shiny::getDefaultReactiveDomain()
  if (!(shiny::isRunning() | inherits(session, "MockShinySession"))) {
    stop("No Shiny app running, it makes no sense to call this function outside of a Shiny app")
  }
  ns <- if (!is.null(session)) session$ns(character(0))

  input_values <- shiny::isolate(shiny::reactiveValuesToList(input))
  utils::assignInMyNamespace("shiny_input_values", input_values)

  if (!skip_init) {
    init_message <-
      paste(
        ns, "Default Shiny inputs initialized:",
        as.character(jsonlite::toJSON(input_values, auto_unbox = TRUE))
      )

    logger::log_level(
      level,
      logger::skip_formatter(trimws(init_message)),
      namespace = namespace
    )
  }

  shiny::observe({
    old_input_values <- shiny_input_values
    new_input_values <- shiny::reactiveValuesToList(input)
    names <- unique(c(names(old_input_values), names(new_input_values)))
    names <- setdiff(names, excluded_inputs)
    if (length(excluded_patterns)) {
      names <- grep(excluded_patterns, names, invert = TRUE, value = TRUE)
    }
    for (name in names) {
      old <- old_input_values[name]
      new <- new_input_values[name]
      if (!identical(old, new)) {
        message <- ifelse(is.null(ns),
          "Shiny input change detected in {name}: {old} -> {new}",
          "Shiny input change detected in {ns} on {name}: {old} -> {new}"
        )
        logger::log_level(level, message, namespace = namespace)
      }
    }
    utils::assignInNamespace("shiny_input_values", new_input_values, ns = "logger")
  })
}
shiny_input_values <- NULL
