load("data-transf/data_base.RData")

#summarize per capita emissions by country
data_countries <- data_base %>% 
  group_by(country,year,region_ar6_6,pop,EU) %>% 
  summarise(GHG_pc=sum(GHG_pc,na.rm=TRUE))  

data_china<-data_countries %>% 
  filter(country=={{COUNTRY}}) %>% 
  rename(region = country)

data_EU<-data_countries %>% 
  filter(EU) %>% 
  select(-country) %>%
  mutate(region_ar6_6 = "EU")

#to show chinas development in rleations to diffrent world regions


data_regions <- data_countries %>% 
  rbind(data_EU) %>% #appending data for EU countries to show in plot
  mutate(pop=replace_na(pop,0)) %>% # check if zero transformation changes statitstics
  group_by(region_ar6_6,year) %>% 
  summarise(GHG_pc=weighted.mean(GHG_pc,pop,na.rm=TRUE)) %>% 
  rename(region = region_ar6_6) %>% 
  filter(region %ni% c("Intl. Aviation", "Intl. Shipping"))

# combining data frames

china_and_regions <- data_regions %>% 
  rbind(data_china) %>%
  filter(year <= {{YEAR}})



