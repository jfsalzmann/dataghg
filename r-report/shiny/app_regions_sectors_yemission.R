setwd("../../")

source('r-imports/init.R')
source('r-analysis/meta.R')

p_load(shiny)


ui = fluidPage(
  
  titlePanel("Regions & Sectors at specific year"),

  sidebarLayout(
      sidebarPanel(
          sliderInput("year",
                      "Year:",
                      min = 1970,
                      max = 2019,
                      value = 2019,
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
         plotOutput("plot1"),
         plotOutput("plot2"),
         plotOutput("plot3")
    )
  )
)


server = function(input, output) {

  setwd("../../")
  PDATA = reactiveValues()
  
  
  .init = reactive({
    
    YEAR = input$year
    GAS = input$gas
    COUNTRY = input$country
    
    source("r-analysis/data_sector_regions_yemission.R", local = TRUE, print.eval = TRUE)
    
  })
  
  
  output$plot1 = renderPlot({
    
    YEAR = input$year
    GAS = input$gas
    COUNTRY = input$country
    .init()
    
    source("r-plots/plot_facet_regions_sectors_yemission_stacked_rel.R", local = TRUE, print.eval = TRUE)
    
  })
  
  
  output$plot2 = renderPlot({
    
    YEAR = input$year
    GAS = input$gas
    COUNTRY = input$country
    .init()
    
    source("r-plots/plot_facet_regions_sectors_yemission_stacked_rel_pc.R", local = TRUE, print.eval = TRUE)
    
  })
  
  
  output$plot3 = renderPlot({
    
    YEAR = input$year
    GAS = input$gas
    COUNTRY = input$country
    .init()
    
    source("r-plots/plot_facet_regions_sectors_yemission_stacked_rel_pg.R", local = TRUE, print.eval = TRUE)
    
  })
  

  
}


shinyApp(ui = ui, server = server)
