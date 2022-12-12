##################################################################################
## INITIAL SETUP
## ---- init-setup ----


rm(list = ls(envir = globalenv()),envir = globalenv())

if (!require("pacman")) install.packages("pacman")
library(pacman)

p_load(magrittr)
p_load(readxl)
p_load(ggplot2)
p_load(tidyverse)
p_load(WDI)
p_load(ggridges)
p_load(eurostat)
p_load(plotly)
p_load(imputeTS)
p_load(openxlsx)


"%cin%" = function(x,y){str_detect(y,x)}
"%xin%" = function(x,y){x %cin% y | y %cin% x}
"%ni%" = Negate("%in%")
"%nci%" = Negate("%cin%")
"%nxi%" = Negate("%xin%")
"%.%" = function(x,y){paste(x,y,sep = "")}
cNA = as.character(NA)
as.numeric.factor = . %>% as.numeric(levels(.))[.]


`?` <- function(x, y) {
  xs <- as.list(substitute(x))
  if (xs[[1]] == as.name("<-")) x <- eval(xs[[3]])
  r <- eval(sapply(strsplit(deparse(substitute(y)), ":"), function(e) parse(text = e))[[2 - as.logical(x)]])
  if (xs[[1]] == as.name("<-")) {
    xs[[3]] <- r
    eval.parent(as.call(xs))
  } else {
    r
  }
}


theme_ghg = function(){ 
  #font <- "Georgia"   #assign font family up front
  
  theme_minimal() %+replace%    #replace elements we want to change
    
    # theme(plot.title =element_blank(),
    #     plot.subtitle = element_blank()
    #   
      # #grid elements
      # panel.grid.major = element_blank(),    #strip major gridlines
      # panel.grid.minor = element_blank(),    #strip minor gridlines
      # axis.ticks = element_blank(),          #strip axis ticks
      # 
      # #since theme_minimal() already strips axis lines, 
      # #we don't need to do that again
      # 
      # #text elements
      # plot.title = element_text(             #title
      #   family = font,            #set font family
      #   size = 20,                #set font size
      #   face = 'bold',            #bold typeface
      #   hjust = 0,                #left align
      #   vjust = 2),               #raise slightly
      # 
      # plot.subtitle = element_text(          #subtitle
      #   family = font,            #font family
      #   size = 14),               #font size
      # 
      # plot.caption = element_text(           #caption
      #   family = font,            #font family
      #   size = 9,                 #font size
      #   hjust = 1),               #right align
      # 
      # axis.title = element_text(             #axis titles
      #   family = font,            #font family
      #   size = 10),               #font size
      # 
      # axis.text = element_text(              #axis text
      #   family = font,            #axis famuly
      #   size = 9),                #font size
      # 
      # axis.text.x = element_text(            #margin for axis text
      #   margin=margin(5, b = 10))
      # 
      # #since the legend often requires manual tweaking 
      # #based on plot content, don't define it here
    )
}


PDATA = list()
DIRECT_PLOTTING = TRUE

COUNTRY = "China"
YEAR = 2019
YEAR_L = 1970
YEAR_U = 2019
FYEAR_L = c(2025,2030,2030,2035,2040)
FYEAR_U = c(2060,2060,2055,2065,2065)
FYEAR_US = 2050
FYEAR_EU = 2050
GAS = "GHG"
