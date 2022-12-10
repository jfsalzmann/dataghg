load(file="data-transf/data_base.RData")
# emissions percapita by YEAR
data_base_lp_pc<-data_base %>% 
  filter(year=={{YEAR}} & country != "Int. Shipping" & country != "Int. Aviation") %>% 
  group_by(country,year,pop,gdp_ppp,GDP_pc,EU) %>% 
  summarise(GHG=sum(GHG),
            GHG_pc=sum(GHG_pc))%>%
  arrange(desc(GHG_pc))

id<-as.character(1:nrow(data_base_lp_pc))
new_names <- paste0(data_base_lp_pc$country," [" %.% id %.% "]")
data_base_lp_pc %<>%
  cbind(country_2 =new_names)

EU<-data_base_lp_pc %>% 
  filter(EU) %>% 
  mutate(country = "EU-27", country_2 = "EU-27") %>% 
  group_by(country, country_2) %>% 
  summarise(GHG=sum(GHG),
            pop = sum(pop),
            GHG_pc=GHG/pop,
            gdp_ppp=sum(gdp_ppp))%>%
  arrange(desc(GHG_pc))




Top<-data_base_lp_pc%>%
  head(10)
relevant<-data_base_lp_pc %>%
  filter(country %in% c("United States","China"))




  

Others<-data_base_lp_pc  %>% 
  filter(country %ni% Top$country  & country %ni% relevant) %>%
  mutate(country ="Other", country_2 = "Other") %>% 
  na.omit() %>% 
  group_by(country,year,country_2) %>% 
  summarise(GHG=sum(GHG),
            pop = sum(pop),
            GHG_pc=GHG/pop,
            gdp_ppp=sum(gdp_ppp))%>%
  arrange(desc(GHG_pc))


#population 50% 

data_base_lp_pc %<>%
  mutate(pop_perc=round(pop/sum(data_base_lp_pc$pop,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_pop_perc = cumsum(coalesce(pop_perc, 0)) + pop_perc*0) 

pop_50_pc<-data_base_lp_pc%>% 
  slice(which.min(abs((1-.$cum_pop_perc)-0.5)))

#Emissions 50 % 
data_base_lp_pc %<>%
  mutate(ghg_perc=round(GHG/sum(data_base_lp_pc$GHG,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_ghg_perc = cumsum(coalesce(ghg_perc, 0)) + ghg_perc*0) 

ghg_50_pc<-data_base_lp_pc%>% 
  slice(which.min(abs((1-.$cum_ghg_perc)-0.5)))

#GDP 50% 
data_base_lp_pc %<>%
  mutate(gdp_perc=round(gdp_ppp/sum(data_base_lp_pc$gdp_ppp,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_gdp_perc = cumsum(coalesce(gdp_perc, 0)) + gdp_perc*0) 

gdp_50_pc<-data_base_lp_pc%>% 
  slice(which.min(abs((1-.$cum_gdp_perc)-0.5)))

# combining countries of  intrest 
data_base_lp_pc<-rbind(Top,relevant,EU,Others,pop_50_pc,ghg_50_pc,gdp_50_pc)  


data_base_lp_pc <- data.frame(
  x=data_base_lp_pc %>% pull(country_2), 
  y=data_base_lp_pc %>% pull(GHG_pc),
  z=data_base_lp_pc %>% pull(country)
) %>% 
  distinct() %>% 
  mutate(y= round(y,2))

# Reorder the data
p_level_pc <- data_base_lp_pc %>%
  arrange(desc(y)) %>% 
  pull(x)  

p_level_pc<-rev(c(p_level_pc[-which(p_level_pc=="Other")],"Other"))

data_base_lp_pc%<>%
  mutate(x = (fct_relevel(x,p_level_pc)))


p_an_pc <- data_base_lp_pc %>%
  arrange(desc(y)) %>% 
  pull(z) 
p_an_pc<-rev(c(p_an_pc[-which(p_an_pc=="Other")],"Other"))
PDATA$data_base_lp_pc<-data_base_lp_pc
PDATA$p_an_pc<-p_an_pc
PDATA$ghg_50_pc<-ghg_50_pc
PDATA$pop_50_pc<-pop_50_pc
PDATA$gdp_50_pc<-gdp_50_pc

