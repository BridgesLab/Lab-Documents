library(shiny)
library(pwr)

# Define UI
ui <- fluidPage(
  titlePanel("Power Analysis"),
  sidebarLayout(
    sidebarPanel(
      numericInput("n", "Sample Size (n)", value = 8, min = 1, step = 1),
      numericInput("alpha", "False Positive Rate (α)", value = 0.05, min = 0, max = 1, step = 0.01),
      numericInput("beta", "False Negative Rate (β)", value = 0.2, min = 0, max = 1, step = 0.01),
      numericInput("effect", "Effect Size (SDs)", value = 0.6, min = 0, step = 0.01),
      actionButton("calculate", "Calculate")
    ),
    mainPanel(
      textOutput("power"),
      textOutput("required_n")
    )
  )
)

# Define server
server <- function(input, output) {
  
  # Calculate power
  observeEvent(input$calculate, {
    required_power <- pwr.t.test(sig.level=input$alpha,d=input$effect,n=input$n)$power
    output$power <- renderText(paste0("The power is: ", round(required_power, 2)))
  })
  
  # Calculate required sample size
  observeEvent(input$calculate, {
    required_n <- pwr.t.test(sig.level=input$alpha,d=input$effect,power=1-input$beta)$n
    output$required_n <- renderText(paste0("The required sample size is: ", round(required_n, 2)))
  })
}

# Run the app
shinyApp(ui = ui, server = server)