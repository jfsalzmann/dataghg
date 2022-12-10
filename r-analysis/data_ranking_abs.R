load(file="data-transf/data_base.RData")
#2019 emissions absolute 
data_base_lp_abs<-data_base %>% 
  filter(year=={{YEAR}} & country != "Int. Shipping" & country != "Int. Aviation") %>% 
  group_by(country,year,pop,gdp_ppp,GDP_pc,EU) %>% 
  summarise(GHG=sum(GHG)/1e6,
            GHG_pc=sum(GHG_pc))%>%
  arrange(desc(GHG))

id<-as.character(1:nrow(data_base_lp_abs))
new_names <- paste0(data_base_lp_abs$country," [" %.% id %.% "]")
data_base_lp_abs %<>%
  cbind(country_2 =new_names)

EU<-data_base_lp_abs %>% 
  filter(EU) %>% 
  mutate(country = "EU-27", country_2 = "EU-27") %>% 
  group_by(country, country_2) %>% 
  summarise(GHG=sum(GHG),
            pop = sum(pop),
            GHG_pc=GHG/pop,
            gdp_ppp=sum(gdp_ppp))%>%
  arrange(desc(GHG))




Top<-data_base_lp_abs%>%
  head(10)
relevant<-data_base_lp_abs %>%
  filter(country %in% c("United States","China"))

Others<-data_base_lp_abs  %>% 
  filter(country %ni% Top$country & country %ni% relevant) %>%
  mutate(country ="Other", country_2 = "Other") %>% 
  na.omit() %>% 
  group_by(country,year,country_2) %>% 
  summarise(GHG=sum(GHG),
            pop = sum(pop),
            GHG_pc=GHG/pop,
            gdp_ppp=sum(gdp_ppp))%>%
  arrange(desc(GHG))

#population 50% 

data_base_lp_abs %<>%
  mutate(pop_perc=round(pop/sum(data_base_lp_abs$pop,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_pop_perc = cumsum(coalesce(pop_perc, 0)) + pop_perc*0) 

pop_50_abs<-data_base_lp_abs%>% 
  slice(which.min(abs((1-.$cum_pop_perc)-0.5)))

#Emissions 50 % 
data_base_lp_abs %<>%
  mutate(ghg_perc=round(GHG/sum(data_base_lp_abs$GHG,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_ghg_perc = cumsum(coalesce(ghg_perc, 0)) + ghg_perc*0) 

ghg_50_abs<-data_base_lp_abs%>% 
  slice(which.min(abs((1-.$cum_ghg_perc)-0.5)))

#GDP 50% 
data_base_lp_abs %<>%
  mutate(gdp_perc=round(gdp_ppp/sum(data_base_lp_abs$gdp_ppp,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_gdp_perc = cumsum(coalesce(gdp_perc, 0)) + gdp_perc*0) 

gdp_50_abs<-data_base_lp_abs%>% 
  slice(which.min(abs((1-.$cum_gdp_perc)-0.5)))

# combining countries of  intrest 
data_base_lp_abs<-rbind(Top,Others,relevant,EU,pop_50_abs,ghg_50_abs,ghg_50_abs)  
  
 
data_base_lp_abs <- data.frame(
  x=data_base_lp_abs %>% pull(country_2), 
  y=data_base_lp_abs %>% pull(GHG),
  z=data_base_lp_abs %>% pull(country)
) %>% 
  distinct() %>% 
  mutate(y= round(y,2))

# Reorder the data
p_level_abs <- data_base_lp_abs %>%
  arrange(desc(y)) %>% 
  pull(x)  

p_level_abs<-rev(c(p_level_abs[-which(p_level_abs=="Other")],"Other"))

data_base_lp_abs%<>%
  mutate(x = (fct_relevel(x,p_level_abs)))


p_an_abs <- data_base_lp_abs %>%
  arrange(desc(y)) %>% 
  pull(z) 
p_an_abs<-rev(c(p_an_abs[-which(p_an_abs=="Other")],"Other"))
PDATA$data_base_lp_abs<-data_base_lp_abs
PDATA$p_an_abs<-p_an_abs
PDATA$ghg_50_abs<-ghg_50_abs
PDATA$pop_50_abs<-pop_50_abs
PDATA$gdp_50_abs<-gdp_50_abs

