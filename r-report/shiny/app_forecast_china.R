setwd("../../")

source('r-imports/init.R')
source('r-analysis/meta.R')

p_load(shiny)


ui = fluidPage(
  
  titlePanel("Emissions Forecast, China vs. EU vs. US"),

  sidebarLayout(
      sidebarPanel(
          sliderInput("year",
                      "Historic Years:",
                      min = 1970,
                      max = 2019,
                      value = c(1970,2019),
                      sep = ""),
          sliderInput("fyear_a",
                      "AFOLU: Assumed Peak Year, Net-Zero Year",
                      min = 2025,
                      max = 2080,
                      value = c(2025,2060),
                      sep = ""),
          sliderInput("fyear_b",
                      "Buildings: Assumed Peak Year, Net-Zero Year",
                      min = 2025,
                      max = 2080,
                      value = c(2030,2060),
                      sep = ""),
          sliderInput("fyear_e",
                      "Energy Systems: Assumed Peak Year, Net-Zero Year",
                      min = 2025,
                      max = 2080,
                      value = c(2030,2055),
                      sep = ""),
          sliderInput("fyear_i",
                      "Industry: Assumed Peak Year, Net-Zero Year",
                      min = 2025,
                      max = 2080,
                      value = c(2035,2065),
                      sep = ""),
          sliderInput("fyear_t",
                      "Transport: Assumed Peak Year, Net-Zero Year",
                      min = 2025,
                      max = 2080,
                      value = c(2040,2065),
                      sep = ""),
          selectInput("gas",
                      "Gas:",
                      meta_gas_list,
                      selected = "GHG"),
          sliderInput("fyear_eu",
                      "vs. EU: Net-Zero Year",
                      min = 2025,
                      max = 2080,
                      value = 2050,
                      sep = ""),
          sliderInput("fyear_us",
                      "vs. US: Net-Zero Year",
                      min = 2025,
                      max = 2080,
                      value = 2050,
                      sep = ""),
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
  DIRECT_PLOTTING = FALSE
  
  
  .init = reactive({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    FYEAR_L = c(input$fyear_a[1],input$fyear_b[1],input$fyear_e[1],input$fyear_i[1],input$fyear_t[1])
    FYEAR_U = c(input$fyear_a[2],input$fyear_b[2],input$fyear_e[2],input$fyear_i[2],input$fyear_t[2])
    FYEAR_EU = input$fyear_eu
    FYEAR_US = input$fyear_us
    GAS = input$gas
    
    source("r-analysis/forecast.R", local = TRUE, print.eval = TRUE)
    
  })
  
  
  output$plot1 = renderPlot({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    FYEAR_L = c(input$fyear_a[1],input$fyear_b[1],input$fyear_e[1],input$fyear_i[1],input$fyear_t[1])
    FYEAR_U = c(input$fyear_a[2],input$fyear_b[2],input$fyear_e[2],input$fyear_i[2],input$fyear_t[2])
    FYEAR_EU = input$fyear_eu
    FYEAR_US = input$fyear_us
    GAS = input$gas
    .init()
    
    source("r-plots/plot_forecast.R", local = TRUE, print.eval = TRUE)
    plot(OUT)
    
  })
  
  
  output$plot2 = renderPlot({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    FYEAR_L = c(input$fyear_a[1],input$fyear_b[1],input$fyear_e[1],input$fyear_i[1],input$fyear_t[1])
    FYEAR_U = c(input$fyear_a[2],input$fyear_b[2],input$fyear_e[2],input$fyear_i[2],input$fyear_t[2])
    FYEAR_EU = input$fyear_eu
    FYEAR_US = input$fyear_us
    GAS = input$gas
    .init()
    
    source("r-plots/plot_forecast_delta.R", local = TRUE, print.eval = TRUE)
    plot(OUT)
    
  })
  

  
}


shinyApp(ui = ui, server = server)
