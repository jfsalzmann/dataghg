load("data-transf/data_kaya.RData")

#normalize to 1 in 2000
data_kaya<-data_kaya %>%
  filter(year>=2000) %>% 
  group_by(country,var) %>% 
  mutate(value=value/first(value))

#get country level data 
data_kaya_countries <- data_kaya %>%
  select(c(year,energy,var,value,country)) 

#get specific data for country of choice/ China
data_kaya_first_country<-data_kaya %>%
  select(c(year,energy,var,value,country)) %>% 
  filter(country=={{COUNTRY}}) %>%
  rename(region = country)

#filter for developed country Data
data_kaya_deved<-data_kaya %>%
  filter(deved) %>%
  group_by(year,energy,var,value,country) %>% 
  rename(region = country) %>% 
  mutate(region = "Developed Countries")

#filter for developing country Data
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

#### intermediate plot for presentation
data_kaya %>% 
  filter(country %in% c("China")) %>%
  ggplot(.,aes(x=year,y=value,color=var)) +
  geom_line(size=1.5) +
  geom_hline(aes(yintercept=1)) +
  theme_bw() +
  scale_color_brewer(palette="Set2",labels=c("Carbon intensity (CO2/energy)",
                                             "Carbon emissions",
                                             "Energy intensity (energy/GDP)",
                                             "GDP per capita (GDP/pop)",
                                             "Population"),
                     guide = guide_legend(reverse = TRUE)) +
  theme(legend.title=element_blank(),
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        text = element_text(size = 25))+
  guides(fill=guide_legend(title="Country/Region"))+
  ggtitle("China's Kaya Identity from 2000-2019")

