library(rsconnect)

# Print a list of app dependencies. Libraries need to be loaded
# before publishing so deployApp() knows what is necessary.
source("../NYC_covid19/app.R")

# Set the account info for deployment.
setAccountInfo(name='dbmi-covid-19',
               token='D88703C0FA69A88D226550D1FDF4C854',
               secret=Sys.getenv("shinyapps_secret"))

# Deploy the application.
deployApp('NYC_covid19')