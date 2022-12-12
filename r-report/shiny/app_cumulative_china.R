setwd("../../")

source('r-imports/init.R')
source('r-analysis/meta.R')

p_load(shiny)


ui = fluidPage(
  
  titlePanel("Cumulative Emissions China vs. EU vs. US, with Forecast Data"),

  sidebarLayout(
      sidebarPanel(
          sliderInput("year",
                      "Years:",
                      min = 1750,
                      max = 2065,
                      value = c(1750,2065),
                      sep = ""),
          selectInput("gas",
                      "Gas:",
                      meta_gas_list[c(1,5)],
                      selected = "GHG"),
    ),

    mainPanel(
         plotlyOutput("plot1"),
         plotlyOutput("plot2")
    )
  )
)


server = function(input, output) {

  setwd("../../")
  PDATA = reactiveValues()
  DIRECT_PLOTTING = FALSE
  
  
  .init = reactive({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    GAS = input$gas
    
    source("r-analysis/data_cumulative_mergeforecast.R", local = TRUE, print.eval = TRUE)
    
  })
  
  
  output$plot1 = renderPlotly({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    GAS = input$gas
    .init()
    
    source("r-plots/plot_cumulative_china_2030.R", local = TRUE, print.eval = TRUE)
    plot(OUT)
    
  })
  
  output$plot2 = renderPlotly({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    GAS = input$gas
    .init()
    
    source("r-plots/plot_cumulative_china_2040.R", local = TRUE, print.eval = TRUE)
    plot(OUT)
    
  })
  

  
}


shinyApp(ui = ui, server = server)
