#' Auto logging input changes in Shiny app
#'
#' This is to be called in the \code{server} section of the Shiny app.
#'
#' Function having very similar behavior as [logger::log_shiny_input_changes()] but adjusted for `teal` needs.
#'
#' @param input passed from Shiny `server`
#' @param excluded_inputs (`character`) character vector of input names to exclude from logging
#' @param excluded_pattern (`character(1)`) `regexp` pattern of names to be excluded from logging
#' @param namespace (`character(1)`) the name of the namespace
#' @param session the Shiny session
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
#'   log_shiny_input_changes(input, excluded_inputs = "password", excluded_pattern = "mean")
#'
#'   output$plot <- renderPlot({
#'     hist(rnorm(1e3, input$mean1, input$sd), main = input$title)
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
    excluded_pattern = "_width$",
    session = shiny::getDefaultReactiveDomain()) {
  stopifnot(inherits(input, "reactivevalues"))
  stopifnot(is.character(namespace) && length(namespace) == 1)
  stopifnot(is.character(excluded_inputs))
  stopifnot(is.character(excluded_pattern) && length(excluded_pattern) == 1)
  stopifnot(
    inherits(session, "session_proxy") ||
    inherits(session, "ShinySession") ||
    inherits(session, "MockShinySession")
  )

  # Log even if written in lower case or numeric values
  log_level <- get_val("TEAL.LOG_LEVEL", "teal.log_level", "INFO")
  if (!is.numeric(log_level)) log_level <- toupper(log_level)
  if (logger::TRACE > logger::as.loglevel(log_level)) {
    # to avoid setting observers when not needed
    return(invisible(NULL))
  }

  ns <- session$ns(character(0))
  reactive_input_list <- shiny::reactive({
    input_list <- shiny::reactiveValuesToList(input)
    input_list[!grepl(excluded_pattern, names(input_list))]
  })
  shiny_input_values <- shiny::reactiveVal(shiny::isolate(reactive_input_list()))

  shiny::observeEvent(reactive_input_list(), {
    old_input_values <- shiny_input_values()
    new_input_values <- reactive_input_list()
    names <- intersect(names(old_input_values), names(new_input_values))
    for (name in names) {
      old <- old_input_values[[name]]
      new <- new_input_values[[name]]
      if (!identical(old, new)) {
        message <- trimws("{ns} Shiny input change detected in {name}: {old} -> {new}")
        logger::log_trace(message, namespace = namespace)
      }
    }
    shiny_input_values(new_input_values)
  })
}
