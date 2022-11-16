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
                      value = c(1970,2019)),
          selectInput("country",
                      "Country:",
                      meta_country_list,
                      selected = "China")
    ),

    mainPanel(
         plotOutput("plot1"),
         plotOutput("plot2")
    )
  )
)


server = function(input, output) {

  setwd("../../")
  PDATA = reactiveValues()
  
  
  .init = reactive({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    COUNTRY = input$country
    
    source("r-analysis/data_per_capita_emissions.R", local = TRUE, print.eval = TRUE)
    
  })
  
  
  output$plot1 = renderPlot({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    COUNTRY = input$country
    .init()
    
    source("r-plots/plot_bar_per_capita_emissions.R", local = TRUE, print.eval = TRUE)
    
  })

  
  output$plot2 = renderPlot({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    COUNTRY = input$country
    .init()
    
    source("r-plots/plot_line_per_capita_emissions_regions.R", local = TRUE, print.eval = TRUE)
    
  })
}


shinyApp(ui = ui, server = server)
