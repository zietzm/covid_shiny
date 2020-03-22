#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(ggplot2)
library(plotly)
library(shiny)
library(tidyverse)

ui <- fluidPage(
  titlePanel("COVID-19 in NYC"),
  
  # --------- Timeline Slider --------- #
  fluidRow(
    column(12, sliderInput("time", "Year:",
                          min = time_min, max = time_max, value = time_min, step=1)
    )
  ),
  
  sidebarLayout(
  # --------- Checkbox --------- #
  sidebarPanel(
    checkboxGroupInput("vars", "Choose:",
                       c("Cylinders" = "cyl",
                         "Transmission" = "am",
                         "Gears" = "gear")),
    width = 2
  ),
  
  # --------- NYC map --------- #
  mainPanel(
    plotlyOutput("nyc_map", height = "100%", width = "90%")
  ), 
  
  position = "right",
  fluid = TRUE)
  
);



# Define server logic required to draw a histogram
server <- function(input, output) {
  # --------- VARIABLES --------- #
  time_min <- 2017
  time_max <- 2018
  
  # --------- NYC HEATMAP --------- #
  output$nyc_map <- renderPlotly({
    ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) + geom_point()
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

