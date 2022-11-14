setwd("../../")

source('r-imports/init.R')
source('r-analysis/meta.R')

p_load(shiny)


ui = fluidPage(
  
  titlePanel("Kaya Decomposition"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("country",
                  "Country:",
                  meta_country_list,
                  selected = "China")
    ),
    
    mainPanel(
      plotOutput("plot1")
    )
  )
)


server = function(input, output) {
  
  setwd("../../")
  PDATA = reactiveValues()
  
  
  .init = reactive({
    
   
  
    COUNTRY = input$country
    source("r-analysis/data_kaya_analysis.R", local = TRUE, print.eval = TRUE)
    
  })
  
  
  output$plot1 = renderPlot({
    
    
    
    COUNTRY = input$country
    .init()
    
    source("r-plots/plot_kaya_country_vs.developed-vs_developing.R", local = TRUE, print.eval = TRUE)
    
  })
}


shinyApp(ui = ui, server = server)
