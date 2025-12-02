# Auto logging input changes in Shiny app

This is to be called in the `server` section of the Shiny app.

## Usage

``` r
log_shiny_input_changes(
  input,
  namespace = NA_character_,
  excluded_inputs = character(),
  excluded_pattern = "_width$",
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- input:

  passed from Shiny `server`

- namespace:

  (`character(1)`) the name of the namespace

- excluded_inputs:

  (`character`) character vector of input names to exclude from logging

- excluded_pattern:

  (`character(1)`) `regexp` pattern of names to be excluded from logging

- session:

  the Shiny session

## Details

Function having very similar behavior as
[`logger::log_shiny_input_changes()`](https://daroczig.github.io/logger/reference/log_shiny_input_changes.html)
but adjusted for `teal` needs.

## Examples

``` r
if (FALSE) { # \dontrun{
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
    hist(rnorm(1e3, input$mean1, input$sd), main = input$title)
  })
}

shinyApp(ui = ui, server = server)
} # }
```
