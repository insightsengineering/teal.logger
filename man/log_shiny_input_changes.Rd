% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/log_shiny_input_changes.R
\name{log_shiny_input_changes}
\alias{log_shiny_input_changes}
\title{Auto logging input changes in Shiny app}
\usage{
log_shiny_input_changes(
  input,
  namespace = NA_character_,
  excluded_inputs = character(),
  excluded_pattern = "_width$"
)
}
\arguments{
\item{input}{passed from Shiny \code{server}}

\item{namespace}{the name of the namespace}

\item{excluded_inputs}{character vector of input names to exclude from logging}

\item{excluded_pattern}{character of length one including a grep pattern of names to be excluded from logging}
}
\description{
This is to be called in the \code{server} section of the Shiny app.
}
\details{
Function having very similar behavior as \code{\link[logger:log_shiny_input_changes]{logger::log_shiny_input_changes()}} but adjusted for \code{teal} needs.
}
\examples{
\dontrun{
library(shiny)

ui <- bootstrapPage(
  numericInput("mean1", "mean1", 0),
  numericInput("mean2", "mean2", 0),
  numericInput("sd", "sd", 1),
  textInput("title", "title", "title"),
  textInput("foo", "This is not used at all, still gets logged", "foo"),
  passwordInput("password", "Password not to be logged", "secret"),
  plotOutput("plot")
)

server <- function(input, output) {
  log_shiny_input_changes(input, excluded_inputs = "password", excluded_pattern = "mean")

  output$plot <- renderPlot({
    hist(rnorm(1e3, input$mean, input$sd), main = input$title)
  })
}

shinyApp(ui = ui, server = server)
}
}
