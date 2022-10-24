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


"%cin%" = function(x,y){str_detect(y,x)}
"%xin%" = function(x,y){x %cin% y | y %cin% x}
"%ni%" = Negate("%in%")
"%nci%" = Negate("%cin%")
"%nxi%" = Negate("%xin%")
"%.%" = function(x,y){paste(x,y,sep = "")}
cNA = as.character(NA)
as.numeric.factor = . %>% as.numeric(levels(.))[.]
