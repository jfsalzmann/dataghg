load(file="data-transf/data_base.RData")
# emissions percapita by YEAR
data_base_lp_con<-data_base %>% 
  filter(year=={{YEAR}} & country != "Int. Shipping" & country != "Int. Aviation") %>% 
  group_by(country,year,pop,gdp_ppp,GDP_pc,EU) %>% 
  summarise(con_co2=sum(con_co2))%>%
  arrange(desc(con_co2))

id<-as.character(1:nrow(data_base_lp_con))
new_names <- paste0(data_base_lp_con$country," [" %.% id %.% "]")
data_base_lp_con %<>%
  cbind(country_2 =new_names)

EU<-data_base_lp_con %>% 
  filter(EU) %>% 
  mutate(country = "EU-27", country_2 = "EU-27") %>% 
  group_by(country, country_2) %>% 
  summarise(con_co2=sum(con_co2),
            pop = sum(pop),
            con_co2_pc=con_co2/pop,
            gdp_ppp=sum(gdp_ppp))%>%
  arrange(desc(con_co2))




Top<-data_base_lp_con%>%
  head(10)
relevant<-data_base_lp_con %>%
  filter(country %in% c("United States","China"))






Others<-data_base_lp_con  %>% 
  filter(country %ni% Top$country  & country %ni% relevant) %>%
  mutate(country ="Other", country_2 = "Other") %>% 
  na.omit() %>% 
  group_by(country,year,country_2) %>% 
  summarise(con_co2=sum(con_co2),
            pop = sum(pop),
            con_co2_pc=con_co2/pop,
            gdp_ppp=sum(gdp_ppp))%>%
  arrange(desc(con_co2))


#population 50% 

data_base_lp_con %<>%
  mutate(pop_perc=round(pop/sum(data_base_lp_con$pop,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_pop_perc = cumsum(coalesce(pop_perc, 0)) + pop_perc*0) 

pop_50_con<-data_base_lp_con%>% 
  slice(which.min(abs((1-.$cum_pop_perc)-0.5)))

#Emissions 50 % 
data_base_lp_con %<>%
  mutate(con_co2_perc=round(con_co2/sum(data_base_lp_con$con_co2,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_con_co2_perc = cumsum(coalesce(con_co2_perc, 0)) + con_co2_perc*0) 

ghg_50_con<-data_base_lp_con%>% 
  slice(which.min(abs((1-.$cum_con_co2_perc)-0.5)))

#GDP 50% 
data_base_lp_con %<>%
  mutate(gdp_perc=round(gdp_ppp/sum(data_base_lp_con$gdp_ppp,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_gdp_perc = cumsum(coalesce(gdp_perc, 0)) + gdp_perc*0) 

gdp_50_con<-data_base_lp_con%>% 
  slice(which.min(abs((1-.$cum_gdp_perc)-0.5)))

# combining countries of  intrest 
data_base_lp_con<-rbind(Top,relevant,EU,Others,pop_50_con,ghg_50_con,gdp_50_con)  


data_base_lp_con <- data.frame(
  x=data_base_lp_con %>% pull(country_2), 
  y=data_base_lp_con %>% pull(con_co2),
  z=data_base_lp_con %>% pull(country)
) %>% 
  distinct() %>% 
  mutate(y= round(y,2))

# Reorder the data
p_level_con <- data_base_lp_con %>%
  arrange(desc(y)) %>% 
  pull(x)  

p_level_con<-rev(c(p_level_con[-which(p_level_con=="Other")],"Other"))

data_base_lp_con%<>%
  mutate(x = (fct_relevel(x,p_level_con)))


p_an_con <- data_base_lp_con %>%
  arrange(desc(y)) %>% 
  pull(z) 
p_an_con<-rev(c(p_an_con[-which(p_an_con=="Other")],"Other"))
PDATA$data_base_lp_con<-data_base_lp_con
PDATA$p_an_con<-p_an_con
PDATA$ghg_50_con<-ghg_50_con
PDATA$pop_50_con<-pop_50_con
PDATA$gdp_50_con<-gdp_50_con

