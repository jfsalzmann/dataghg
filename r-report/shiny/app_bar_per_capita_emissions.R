setwd("../../")

source('r-imports/init.R')
source('r-analysis/meta.R')

p_load(shiny)

ui = fluidPage(
  
  titlePanel("GHG Emissions"),

  sidebarLayout(
      sidebarPanel(
          sliderInput("year",
                      "Year:",
                      min = 1970,
                      max = 2019,
                      value = 2019),
          selectInput("country",
                      "Country:",
                      meta_country_list,
                      selected = "CHN"
                      )
    ),

    mainPanel(
         plotOutput("distPlot")
    )
  )
)


server = function(input, output) {

  setwd("../../")
  
  output$distPlot = renderPlot({
    
    YEAR = input$year
    
    source("r-analysis/per_capita_emissions_china_and_regions.R", local = TRUE, print.eval = TRUE)
    source("r-plots/plot_bar_per_capita_emissions_2019.R", local = TRUE, print.eval = TRUE)
    
  })
}


shinyApp(ui = ui, server = server)
