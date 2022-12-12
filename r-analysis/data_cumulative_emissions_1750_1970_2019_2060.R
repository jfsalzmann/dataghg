load("data-transf/data_hist_co2.RData")
load("data-transf/data_base.RData")


# cumulative co2 untill 1970
data_co2_1750_EU <-data_hist_co2%>% 
    filter(EU) %>% 
  group_by( year) %>% 
  summarise(co2=sum(CO2_FFI,na.rm=T)) %>% 
  mutate(country = "EU-27")
    
data_co2_1750_US_CH<-data_hist_co2 %>% 
 # filter(ISO %in% c("USA","CHN")) %>% 
  rename("co2"=CO2_FFI) %>% 
  select(country,year,co2)

data_cco2_1750<-  rbind(data_co2_1750_US_CH,data_co2_1750_EU) %>% 
  filter(year <= 1970)

data_cco2_1750%<>%
  select(co2,year,country) %>%
  mutate(GHG =co2)
  
#combine with 1970 Data 
  
data_ghg_1970_EU <-data_base%>% 
  filter(EU) %>% 
  group_by(year) %>% 
  summarise(GHG=sum(GHG,na.rm=T),
            co2=sum(CO2,na.rm=T)) %>% 
  mutate(country = "EU-27")

data_cghg_1750_2019<-data_base %>% 
  #filter(ISO %in% c("USA","CHN")) %>% 
  select(country,year,GHG,CO2) %>% 
  group_by(country,year) %>% 
  summarise(GHG=sum(GHG,na.rm=T),
            co2=sum(CO2,na.rm=T)) %>% 
  rbind(data_ghg_1970_EU,data_cco2_1750) %>%
  arrange(year) %>% 
  group_by(country) %>% 
  mutate(cum_ghg = cumsum(coalesce(GHG, 0)) + GHG*0,
         cum_co2 = cumsum(coalesce(co2, 0)) + co2*0)

percentages<-data_cghg_1750_2019 %>% 
  filter(year==2019) %>% 
  ungroup() %>% 
  mutate(perc_ghg = cum_ghg/sum(cum_ghg,na.rm = T),
         perc_co2 = cum_co2/sum(cum_co2,na.rm=T))

data_cghg_1750_2019 %<>% 
  filter(country %in% c("United States","China", "EU-27"))
save(data_cghg_1750_2019,file="data-transf/data_cghg_1750_2019.RData")


  