load("data-transf/data_kaya.RData")



#for regions ar6 
data_kaya_regions<-data_kaya%>%
mutate(dev_status_reg = case_when(country=={{COUNTRY}} ~ as.character({{COUNTRY}}),
       country!={{COUNTRY}} ~ dev_status_reg)) %>% 
group_by(dev_status_reg, year) %>% 
  na.omit() %>% 
  summarise(CO2 = sum(CO2),
            energy = sum(energy),
            GDP = sum(GDP_pc*pop),
            pop = sum(pop),
            GDP_pc = GDP/pop) %>% 
  mutate(energy_intensity = energy/GDP_pc) %>%
  mutate(carbon_intensity = CO2/energy) %>%
  na.omit() %>% 
  pivot_longer(c(CO2,pop,GDP_pc,energy_intensity,carbon_intensity),names_to = "var",values_to = "value") %>% 
  filter(year>=2000) %>% 
  group_by(dev_status_reg,var) %>% 
  mutate(value=value/first(value))

# for income class
data_kaya_incomelevels<-data_kaya%<>%
  mutate(dev_status_income = case_when(country=={{COUNTRY}} ~ as.character({{COUNTRY}}),
                                    country!={{COUNTRY}} ~ dev_status_income)) %>% 
  group_by(dev_status_income, year) %>% 
  na.omit() %>% 
  summarise(CO2 = sum(CO2),
            energy = sum(energy),
            GDP = sum(GDP_pc*pop),
            pop = sum(pop),
            GDP_pc = GDP/pop) %>% 
  mutate(energy_intensity = energy/GDP_pc) %>%
  mutate(carbon_intensity = CO2/energy) %>%
  na.omit() %>% 
  pivot_longer(c(CO2,pop,GDP_pc,energy_intensity,carbon_intensity),names_to = "var",values_to = "value") %>% 
  filter(year>=2000) %>% 
   group_by(dev_status_income,var) %>% 
   mutate(value=value/first(value))


#normalize to 1 in 2000
# #data_kaya<-data_kaya %>%
#   
# 
# #get country level data 
# data_kaya_countries <- data_kaya %>%
#   select(c(year,energy,var,value,country)) 
# 
# #get specific data for country of choice/ China
# data_kaya_first_country<-data_kaya %>%
#   select(c(year,energy,var,value,country)) %>% 
#   filter(country=={{COUNTRY}}) %>%
#   rename(region = country)
# 
# #filter for developed country Data -
# data_kaya_deved<-data_kaya %>%
#   filter(deved) %>%
#   group_by(year,energy,var,value,country) %>% 
#   rename(region = country) %>% 
#   mutate(region = "Developed Countries")
# 
# #filter for developing country Data
# data_kaya_deving<-data_kaya %>%
#   filter(deving_woc) %>%
#   select(c(year,energy,var,value,country)) %>% 
#   rename(region = country) %>% 
#   mutate(region = "Developing Countries")


#create the income level data
# data_kaya_l_income<-data_kaya %>%
#   filter(dev_status_income == "Low income") %>%
#   select(c(year,energy,var,value,country)) %>% 
#   rename(region = country) %>% 
#   mutate(region = "Low income")
# 
# data_kaya_lm_income<-data_kaya %>%
#   filter(dev_status_income == "Lower-middle income") %>%
#   select(c(year,energy,var,value,country)) %>% 
#   rename(region = country) %>% 
#   mutate(region = "Lower-middle income")
# 
# data_kaya_um_income<-data_kaya %>%
#   filter(dev_status_income == "Upper-middle income") %>%
#   select(c(year,energy,var,value,country)) %>% 
#   rename(region = country) %>% 
#   mutate(region = "Upper-middle income")
# 
# data_kaya_h_income<-data_kaya %>%
#   filter(dev_status_income == "High income") %>%
#   select(c(year,energy,var,value,country)) %>% 
#   rename(region = country) %>% 
#   mutate(region = "High income")
# #to show China's development in releation to developing or developed nations
# 
# 
# kaya_regions <- data_kaya_first_country %>%
#   rbind(data_kaya_deved) %>% #appending data for developed  countries to show in plot
#   rbind(data_kaya_deving) %>% #appending data for developing countries without china
#   group_by(region,year,var) %>% 
#   summarise(value=weighted.mean(value,energy,na.rm=TRUE))
# 
# 
# kaya_incomelevels <- data_kaya_first_country %>%
#   rbind(data_kaya_l_income,data_kaya_lm_income,data_kaya_um_income,data_kaya_h_income) %>% #appending data for developed  countries to show in plot
#   #appending data for developing countries without china
#   group_by(region,year,var) %>% 
#   summarise(value=weighted.mean(value,energy,na.rm=TRUE))
#make data available to shiny

PDATA$kaya_regions <-data_kaya_regions
PDATA$kaya_incomelevels <-data_kaya_incomelevels

