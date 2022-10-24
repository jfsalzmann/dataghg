setwd("../../")

source('r-imports/init.R')

p_load(shiny)

ui = fluidPage(

    titlePanel("GHG Emissions"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("year",
                        "Year:",
                        min = 1970,
                        max = 2019,
                        value = 2019)
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
    
    source("r-analysis/china_and_regions.R", local = TRUE, print.eval = TRUE)
    source("r-plots/china_and_regions.R", local = TRUE, print.eval = TRUE)
    
  })
}


shinyApp(ui = ui, server = server)
