load("data-transf/data_kaya.RData")

#normalize to 1 in 2000
data_kaya_tests<-data_kaya %>%
  group_by(country,var) %>% 
  summarise(value=value/first(value))

data_kaya_countries <- data_kaya %>%
  select(c(year,energy,var,value,country)) 


data_kaya_first_country<-data_kaya %>%
  select(c(year,energy,var,value,country)) %>% 
  filter(country=={{COUNTRY}}) %>%
  rename(region = country)


data_kaya_deved<-data_kaya %>%
  filter(deved) %>%
  group_by(year,energy,var,value,country) %>% 
  rename(region = country) %>% 
  mutate(region = "Developed Countries")

data_kaya_deving<-data_kaya %>%
  filter(deving_woc) %>%
  select(c(year,energy,var,value,country)) %>% 
  rename(region = country) %>% 
  mutate(region = "Developing Countries")

#to show China's development in releation to developing or developed nations


kaya_regions <- data_kaya_first_country %>%
  rbind(data_kaya_deved) %>% #appending data for developed  countries to show in plot
  rbind(data_kaya_deving) %>% #appending data for developing countries without china
  group_by(region,year,var) %>% 
  summarise(value=weighted.mean(value,energy,na.rm=TRUE))


#make data available to shiny
PDATA$kaya_regions <-kaya_regions

