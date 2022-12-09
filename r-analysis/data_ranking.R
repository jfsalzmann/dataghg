
#2019 emissions absolute 
data_base_2019<-data_base %>% 
  filter(year==2019 & country != "Int. Shipping" & country != "Int. Aviation") %>% 
  group_by(country,year,pop,gdp_ppp) %>% 
  summarise(GHG=sum(GHG),
            GHG_pc=sum(GHG_pc))%>%
  arrange(desc(GHG))



Top<-data_base_2019 %>%
  head(10)

Bottom<-data_base_2019  %>% 
  tail(5)

Median_pc<-data_base_2019 %>%
  na.omit()

Median_nr<-data_base_2019 %>%
  na.omit() %>% 
  pull(GHG_pc) %>% 
  median( na.rm = T) 

a<-which.min(abs(Median_pc$GHG_pc-Median_nr))
Median_pc<-Median_pc[a,]



#population 50% 

data_base_2019 %<>%
  mutate(pop_perc=round(pop/sum(data_base_2019$pop,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_pop_perc = cumsum(coalesce(pop_perc, 0)) + pop_perc*0) 


pop_50<-data_base_2019%>% 
  slice(which.min(abs((1-.$cum_pop_perc)-0.5)))

#Emissions 50 % 



data_base_2019 %<>%
  mutate(ghg_perc=round(GHG/sum(data_base_2019$GHG,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_ghg_perc = cumsum(coalesce(ghg_perc, 0)) + ghg_perc*0) 


ghg_50<-data_base_2019%>% 
  slice(which.min(abs((1-.$cum_ghg_perc)-0.5)))

#GDP 50% 

data_base_2019 %<>%
  mutate(gdp_perc=round(gdp_ppp/sum(data_base_2019$gdp_ppp,na.rm = T),3)) %>% 
  ungroup() %>% 
  mutate(cum_gdp_perc = cumsum(coalesce(gdp_perc, 0)) + gdp_perc*0) 


gdp_50<-data_base_2019%>% 
  slice(which.min(abs((1-.$cum_gdp_perc)-0.5)))

# combining intrest 
data_rank_abs_ghg<-rbind(Top,Median_pc,Bottom,pop_50,ghg_50,gdp_50)  
  

 
data <- data.frame(
  x=data_rank_abs_ghg$country, 
  y=data_rank_abs_ghg$GHG
)

# Reorder the data
data <- data %>%
  distinct() %>% 
  arrange(y) %>% 
  mutate(x=factor(x,x))

# Plot
p <- ggplot(data, aes(x=x, y=y)) +
  geom_segment(
    aes(x=x, xend=x, y=0, yend=y), 
    color=ifelse(data$x == {{COUNTRY}}, "red", "grey"), 
    size=ifelse(data$x  == {{COUNTRY}}, 1.3, 0.7)
  ) +
  geom_point(
    color=ifelse(data$x == {{COUNTRY}}, "red", 
                 ifelse(data$x == "Moldova", "blue",
                        ifelse(data$x == "Indonesia", "green","grey"))), 
    size=ifelse(data$x  == {{COUNTRY}}, 3, 2)) +
  theme_ghg() +
  coord_flip() +
  theme(
    legend.position="none"
  ) +
  xlab("") +
  ylab("Absolute GHG emissions, (Mt. CO2 eq)") +
  ggtitle("Responsibility 1: Absolute Emissions Ranking", subtitle = "Top Emitters; Median Emitter ; Lowest Emitters")

p + annotate("text", x=grep("Moldova", data$x), y=data$y[which(data$x=="Moldova")]*0.8, 
             label="Median per capita  Emitter at ( 4.47 Mt Co2 EQ per Capita) ", 
             color="blue", size=2.5 , angle=0, fontface="bold", vjust =1, hjust=-0.2) +
  annotate("text", x=grep("China", data$x), y=data$y[which(data$x=="China")]*0.8, 
           label="Top absolute Emitter at (1.4*1e+10 Mt. CO2 eq) ", 
           color="red", size=2.5 , angle=0, fontface="bold", vjust =1.2, hjust=0.4) 

