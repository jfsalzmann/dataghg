setwd("../../")

source('r-imports/init.R')
source('r-analysis/meta.R')

p_load(shiny)


ui = fluidPage(
  
  titlePanel("Regions & Sectors"),

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
                      selected = "China")
    ),

    mainPanel(
         plotOutput("plot1_1"),
         plotOutput("plot1_2"),
         plotOutput("plot2_1"),
         plotOutput("plot2_2"),
         plotOutput("plot3")
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
    
    source("r-analysis/data_sector_regions.R", local = TRUE, print.eval = TRUE)
    
  })
  
  
  output$plot1_1 = renderPlot({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    COUNTRY = input$country
    .init()
    
    source("r-plots/plot_facet_regions_sectors_emissions.R", local = TRUE, print.eval = TRUE)
    
  })
  
  
  output$plot1_2 = renderPlot({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    COUNTRY = input$country
    .init()
    
    source("r-plots/plot_facet_regions_sectors_emissions_gdp.R", local = TRUE, print.eval = TRUE)
    
  })
  
  output$plot2_1 = renderPlot({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    COUNTRY = input$country
    .init()
    
    source("r-plots/plot_facet_regions_sectors_emissions_abs.R", local = TRUE, print.eval = TRUE)
    
  })
  
  
  output$plot2_2 = renderPlot({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    COUNTRY = input$country
    .init()
    
    source("r-plots/plot_facet_regions_sectors_emissions_absavg.R", local = TRUE, print.eval = TRUE)
    
  })
  
  
  output$plot3 = renderPlot({
    
    YEAR_L = input$year[1]
    YEAR_U = input$year[2]
    COUNTRY = input$country
    .init()
    
    source("r-plots/plot_facet_regions_sectors_emissions_rel.R", local = TRUE, print.eval = TRUE)
    
  })

  
}


shinyApp(ui = ui, server = server)
