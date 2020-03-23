library(tidyverse)
library(sf)
library(shiny)
library(leaflet)
library(shinydashboard)

tract_shapes <- read_sf('shapefiles/nyc_census_tracts.shp')

combined_tract_df <- read_tsv('data/census/combined_tract_population_2017_2018.tsv',
                              col_types = cols(GEOID = col_character(), estimate = col_double(),
                                               year = col_double(), popup = col_character()))

plot_df <- tract_shapes %>%
    inner_join(combined_tract_df, by = 'GEOID')


# Color palette range is wrong. Uses complete range even though only groups are
#  shown at one time.
pal <- colorNumeric(palette = "viridis", domain = plot_df$estimate, n = 10)


ui <- dashboardPage(
    dashboardHeader(title = "DBMI COVID-19"),
    dashboardSidebar(),  # Not sure what we might want in the left pane
    dashboardBody(
        fluidRow(
            box(
                title = "Date",
                sliderInput("date_slider",
                            NULL,
                            min = as.Date("2017-01-01"),
                            max = as.Date("2018-01-01"),
                            value = as.Date("2017-01-01"),
                            timeFormat="%Y")
            ),
            column(4,
              selectInput('sex', 'Sex', c('male', 'female', 'total'))
              # This would be the place for other data filters like race, comorbidities, etc.
            )
        ),
        fluidRow(
          box(
              width = 6,
              leafletOutput("nycmap"),
          ),
        )
  )
)


server <- function(input, output) {
  output$nycmap <- renderLeaflet({
    plot_df %>%
      filter(year == as.numeric(format(input$date_slider,'%Y')) & sex == input$sex) %>%
      leaflet(height = "100%") %>%
      addProviderTiles(provider = "CartoDB.Positron") %>%
      addPolygons(popup = ~ popup,
                  stroke = FALSE,
                  smoothFactor = 0,
                  fillOpacity = 0.7,
                  color = ~ pal(estimate)) %>%
      addLegend("bottomright",
                pal = pal,
                values = ~ estimate,
                title = "Population",
                opacity = 1)
  })
}

shinyApp(ui, server)
