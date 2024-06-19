#' Auto logging input changes in Shiny app
#'
#' This is to be called in the \code{server} section of the Shiny app.
#'
#' Function having very similar behavior as [logger::log_shiny_input_changes()] but adjusted for `teal` needs.
#'
#' @param input passed from Shiny \code{server}
#' @param excluded_inputs character vector of input names to exclude from logging
#' @param excluded_patterns character of length one including a grep pattern of names to be excluded from logging
#' @param namespace the name of the namespace
#' @examples
#' \dontrun{
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
#' @export
log_shiny_input_changes <- function(
    input,
    namespace = NA_character_,
    excluded_inputs = character(),
    excluded_patterns = "_width$") {
  session <- shiny::getDefaultReactiveDomain()
  if (!(shiny::isRunning() || inherits(session, "MockShinySession"))) {
    stop("No Shiny app running, it makes no sense to call this function outside of a Shiny app")
  }
  ns <- ifelse(!is.null(session), session$ns(character(0)), "")

  # utils::assignInMyNamespace and utils::assignInNamespace are needed
  # so that observer is executed only once, not twice.
  input_values <- shiny::isolate(shiny::reactiveValuesToList(input))
  utils::assignInMyNamespace("shiny_input_values", input_values)

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
        message <- trimws("{ns} Shiny input change detected in {name}: {old} -> {new}")
        logger::log_trace(message, namespace = namespace)
      }
    }
    utils::assignInNamespace("shiny_input_values", new_input_values, ns = "teal.logger")
  })
}
shiny_input_values <- NULL
