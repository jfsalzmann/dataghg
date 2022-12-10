load(file="data-transf/data_base.RData")
#2019 emissions absolute 
data_base_lp_gdp<-data_base %>% 
  filter(year=={{YEAR}} & country != "Int. Shipping" & country != "Int. Aviation") %>% 
  group_by(country,year,pop,gdp_ppp,GDP_pc,EU) %>% 
  summarise(GHG = sum(GHG)) %>% 
  arrange(desc(gdp_ppp))

id<-as.character(1:nrow(data_base_lp_gdp))
new_names <- paste0(data_base_lp_gdp$country," [" %.% id %.% "]")
data_base_lp_gdp %<>%
  cbind(country_2 =new_names)

EU<-data_base_lp_gdp %>% 
  filter(EU) %>% 
  mutate(country = "EU-27", country_2 = "EU-27") %>% 
  group_by(country, country_2) %>% 
  summarise(pop = sum(pop),
            GHG = sum(GHG),
            gdp_ppp=sum(gdp_ppp),
            gdp_pc=gdp_ppp/pop)%>%
  arrange(desc(gdp_ppp))




Top<-data_base_lp_gdp%>%
  head(10)
relevant<-data_base_lp_gdp %>%
  filter(country %in% c("United States","China"))

Others<-data_base_lp_gdp  %>% 
  filter(country %ni% Top$country & country %ni% relevant) %>%
  mutate(country ="Other", country_2 = "Other") %>% 
  na.omit() %>% 
  group_by(country,year,country_2) %>% 
  summarise(pop = sum(pop),
            GHG = sum(GHG),
            gdp_ppp=sum(gdp_ppp),
            gdp_pc=gdp_ppp/pop)%>%
  arrange(desc(gdp_ppp))

#population 50% 

data_base_lp_gdp %<>%
  mutate(pop_perc=round(pop/sum(data_base_lp_gdp$pop,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_pop_perc = cumsum(coalesce(pop_perc, 0)) + pop_perc*0) 

pop_50_gdp<-data_base_lp_gdp%>% 
  slice(which.min(abs((1-.$cum_pop_perc)-0.5)))

#Emissions 50 % 
data_base_lp_gdp %<>%
  mutate(ghg_perc=round(GHG/sum(data_base_lp_gdp$GHG,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_ghg_perc = cumsum(coalesce(ghg_perc, 0)) + ghg_perc*0) 

ghg_50_gdp<-data_base_lp_gdp%>% 
  slice(which.min(abs((1-.$cum_ghg_perc)-0.5)))

#GDP 50% 
data_base_lp_gdp %<>%
  mutate(gdp_perc=round(gdp_ppp/sum(data_base_lp_gdp$gdp_ppp,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_gdp_perc = cumsum(coalesce(gdp_perc, 0)) + gdp_perc*0) 

gdp_50_gdp<-data_base_lp_gdp%>% 
  slice(which.min(abs((1-.$cum_gdp_perc)-0.5)))

# combining countries of  intrest 
data_base_lp_gdp<-rbind(Top,Others,relevant,EU,pop_50_gdp,ghg_50_gdp,ghg_50_gdp)  


data_base_lp_gdp <- data.frame(
  x=data_base_lp_gdp %>% pull(country_2), 
  y=data_base_lp_gdp %>% pull(gdp_ppp),
  z=data_base_lp_gdp %>% pull(country)
) %>% 
  distinct() %>% 
  mutate(y= round(y,2))

# Reorder the data
p_level_gdp <- data_base_lp_gdp %>%
  arrange(desc(y)) %>% 
  pull(x)  

p_level_gdp<-rev(c(p_level_gdp[-which(p_level_gdp=="Other")],"Other"))

data_base_lp_gdp%<>%
  mutate(x = (fct_relevel(x,p_level_gdp)))


p_an_gdp <- data_base_lp_gdp %>%
  arrange(desc(y)) %>% 
  pull(z) 
p_an_gdp<-rev(c(p_an_gdp[-which(p_an_gdp=="Other")],"Other"))
PDATA$data_base_lp_gdp<-data_base_lp_gdp
PDATA$p_an_gdp<-p_an_gdp
PDATA$ghg_50_gdp<-ghg_50_gdp
PDATA$pop_50_gdp<-pop_50_gdp
PDATA$gdp_50_gdp<-gdp_50_gdp

