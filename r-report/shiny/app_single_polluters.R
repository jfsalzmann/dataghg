setwd("../../")

source('r-imports/init.R')
source('r-analysis/meta.R')

p_load(shiny)


ui = fluidPage(
  
  titlePanel("Single Polluters"),

  sidebarLayout(
      sidebarPanel(
          sliderInput("year",
                      "Year:",
                      min = 1970,
                      max = 2019,
                      value = c(1970,2019),
                      sep = ""),
          selectInput("country",
                      "Country:",
                      meta_country_list,
                      selected = "China"),
          selectInput("gas",
                      "Gas:",
                      meta_gas_list,
                      selected = "GHG")
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
    COUNTRY = input$country
    GAS = input$gas
    
    source("r-analysis/data_single_polluters.R", local = TRUE, print.eval = TRUE)
    
  })
  
  
  output$plot1 = renderPlotly({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    COUNTRY = input$country
    GAS = input$gas
    .init()
    
    source("r-plots/plot_single_polluters_stacked_abs.R", local = TRUE, print.eval = TRUE)
    plot(OUT)
    
  })
  
  
  output$plot2 = renderPlotly({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    COUNTRY = input$country
    GAS = input$gas
    .init()
    
    source("r-plots/plot_single_polluters_stacked_rel.R", local = TRUE, print.eval = TRUE)
    plot(OUT)
    
  })
  

  
}


shinyApp(ui = ui, server = server)
