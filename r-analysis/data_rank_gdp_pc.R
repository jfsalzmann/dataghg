load(file="data-transf/data_base.RData")
#2019 emissions absolute 
data_base_lp_gdp_pc<-data_base %>% 
  filter(year=={{YEAR}} & country != "Int. Shipping" & country != "Int. Aviation") %>% 
  group_by(country,year,pop,gdp_ppp,GDP_pc,EU) %>% 
  summarise(GHG = sum(GHG)) %>% 
  arrange(desc(GDP_pc))

id<-as.character(1:nrow(data_base_lp_gdp_pc))
new_names <- paste0(data_base_lp_gdp_pc$country," [" %.% id %.% "]")
data_base_lp_gdp_pc %<>%
  cbind(country_2 =new_names)

EU<-data_base_lp_gdp_pc %>% 
  filter(EU) %>% 
  mutate(country = "EU-27", country_2 = "EU-27") %>% 
  group_by(country, country_2) %>% 
  summarise(pop = sum(pop),
            GHG = sum(GHG),
            gdp_ppp=sum(gdp_ppp),
            GDP_pc=gdp_ppp/pop)%>%
  arrange(desc(GDP_pc))




Top<-data_base_lp_gdp_pc%>%
  head(10)
relevant<-data_base_lp_gdp_pc %>%
  filter(country %in% c("United States","China"))

Others<-data_base_lp_gdp_pc  %>% 
  filter(country %ni% Top$country & country %ni% relevant) %>%
  mutate(country ="Other", country_2 = "Other") %>% 
  na.omit() %>% 
  group_by(country,year,country_2) %>% 
  summarise(pop = sum(pop),
            GHG = sum(GHG),
            gdp_ppp=sum(gdp_ppp),
            GDP_pc=gdp_ppp/pop)%>%
  arrange(desc(GDP_pc))

#population 50% 

data_base_lp_gdp_pc %<>%
  mutate(pop_perc=round(pop/sum(data_base_lp_gdp_pc$pop,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_pop_perc = cumsum(coalesce(pop_perc, 0)) + pop_perc*0) 

pop_50_gdp_pc<-data_base_lp_gdp_pc%>% 
  slice(which.min(abs((1-.$cum_pop_perc)-0.5)))

#Emissions 50 % 
data_base_lp_gdp_pc %<>%
  mutate(ghg_perc=round(GHG/sum(data_base_lp_gdp_pc$GHG,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_ghg_perc = cumsum(coalesce(ghg_perc, 0)) + ghg_perc*0) 

ghg_50_gdp_pc<-data_base_lp_gdp_pc%>% 
  slice(which.min(abs((1-.$cum_ghg_perc)-0.5)))

#GDP 50% 
data_base_lp_gdp_pc %<>%
  mutate(gdp_perc=round(gdp_ppp/sum(data_base_lp_gdp_pc$gdp_ppp,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_gdp_perc = cumsum(coalesce(gdp_perc, 0)) + gdp_perc*0) 

gdp_50_gdp_pc<-data_base_lp_gdp_pc%>% 
  slice(which.min(abs((1-.$cum_gdp_perc)-0.5)))

# combining countries of  intrest 
data_base_lp_gdp_pc<-rbind(Top,Others,relevant,EU,pop_50_gdp_pc,ghg_50_gdp_pc,ghg_50_gdp_pc)  


data_base_lp_gdp_pc <- data.frame(
  x=data_base_lp_gdp_pc %>% pull(country_2), 
  y=data_base_lp_gdp_pc %>% pull(GDP_pc),
  z=data_base_lp_gdp_pc %>% pull(country)
) %>% 
  distinct() %>% 
  mutate(y= round(y,2))

# Reorder the data
p_level_gdp_pc <- data_base_lp_gdp_pc %>%
  arrange(desc(y)) %>% 
  pull(x)  

p_level_gdp_pc<-rev(c(p_level_gdp_pc[-which(p_level_gdp_pc=="Other")],"Other"))

data_base_lp_gdp_pc%<>%
  mutate(x = (fct_relevel(x,p_level_gdp_pc)))


p_an_gdp_pc <- data_base_lp_gdp_pc %>%
  arrange(desc(y)) %>% 
  pull(z) 
p_an_gdp_pc<-rev(c(p_an_gdp_pc[-which(p_an_gdp_pc=="Other")],"Other"))
PDATA$data_base_lp_gdp_pc<-data_base_lp_gdp_pc
PDATA$p_an_gdp_pc<-p_an_gdp_pc
PDATA$ghg_50_gdp_pc<-ghg_50_gdp_pc
PDATA$pop_50_gdp_pc<-pop_50_gdp_pc
PDATA$gdp_50_gdp_pc<-gdp_50_gdp_pc

