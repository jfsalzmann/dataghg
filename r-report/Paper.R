# This is the R code used in the Markdown document. 
# It is organised in sections like setup-ex below, and will be
# included in the Markdown main file using the section name.



##################################################################################
## ---- init ----

source('r-imports/init.R')
source('r-analysis/meta.R')
theme_ghg = function(){ 
  theme_minimal() %+replace%
    theme(
      plot.title =element_blank(),
      plot.subtitle = element_blank()
    )
}
DIRECT_PLOTTING = F