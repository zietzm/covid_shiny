library(rsconnect)

# Print a list of app dependencies. Libraries need to be loaded
# before publishing so deployApp() knows what is necessary.
library(tidyverse)
library(sf)
library(shiny)
library(shinyWidgets)
library(leaflet)
library(shinydashboard)
library(dashboardthemes)

args <- commandArgs(trailingOnly = T)

# Set the account info for deployment.
setAccountInfo(name='dbmi-covid-19',
               token='D88703C0FA69A88D226550D1FDF4C854',
               secret=args[1])

# Deploy the application.
deployApp('NYC_covid19')
