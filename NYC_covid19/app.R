library(tidyverse)
library(sf)
library(shiny)
library(shinyWidgets)
library(leaflet)
library(shinydashboard)
library(dashboardthemes)

#############
# load data #
#############

# nyc shape files
plot_df <- inner_join(
  # nyc census tract shapefile
  read_sf('shapefiles/nyc_census_tracts.shp'),
  # nyc census data
  read_tsv('data/census/combined_tract_population_2017_2018.tsv',
                      col_types = cols(GEOID = col_character(), estimate = col_double(),
                                       year = col_double(), popup = col_character())),
  # join on GEOID
  by = 'GEOID')

########################
# assign color palette #
########################

pal <- colorNumeric(palette = "YlOrRd", domain = plot_df$estimate, n = 10)

# create dashboard Sidebar

ui <- dashboardPage(skin = "black",
    dashboardHeader(title = "NYC COVID Tracker"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Map", tabName = "map", icon = icon("globe-americas")),
        menuItem("Information", tabName = "info", icon = icon("info")),
        menuItem("FAQ", icon = icon("question"), tabName = "faq",
                 badgeLabel = "new", badgeColor = "green"),
        chooseSliderSkin("Modern", 'black'),
        sliderInput("date_slider",
                    'Date',
                    min = as.Date("2017-01-01"),
                    max = as.Date("2018-01-01"),
                    value = as.Date("2017-01-01"),
                    timeFormat="%Y",
                    step = 365),
        selectInput('sex',
                    'Sex',
                    c('male', 'female', 'total')))),
    dashboardBody(shinyDashboardThemes(theme = "grey_dark"),
        fluidRow(
          box(width = 12,
              leafletOutput("nycmap", height = 600)))))


server <- function(input, output) {
  output$nycmap <- renderLeaflet({
    plot_df %>%
      filter(year == as.numeric(format(input$date_slider,'%Y')) & sex == input$sex) %>%
      leaflet(height = "100%") %>%
      addProviderTiles(provider = "CartoDB.DarkMatter") %>%
      addPolygons(popup = ~ popup,
                  stroke = FALSE,
                  smoothFactor = 0,
                  fillOpacity = 0.4,
                  color = ~ pal(estimate)) %>%
      addLegend("bottomright",
                pal = pal,
                values = ~ estimate,
                title = "Population",
                opacity = 1)
  })
}

shinyApp(ui, server)