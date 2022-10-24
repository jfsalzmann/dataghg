#set levels 

plot_level<-country_and_regions %>%
  filter(year=={{YEAR}}) %>% 
  filter(region!={{COUNTRY}}) %>%
  arrange(desc(GHG_pc)) %>% 
  pull(region)

plot_level<-c(COUNTRY,plot_level)

#plot

country_and_regions %>%
  filter(year=={{YEAR}}) %>%
  ggplot(., aes(y=GHG_pc,x=factor(region,levels=plot_level), fill=as.factor(region) )) + 
  geom_bar( stat = 'identity') +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+             
  ylab("Percapita Emissions (GtCO2eq)") +   
  theme_ghg()+                               
  scale_fill_brewer(palette="Set2") +       
  theme(axis.title.x = element_blank(), 
        axis.text.x = element_text(angle = 45, vjust = 1, hjust=1),
        legend.position="none") +   
  ggtitle("Per Capita Emissions " %.% COUNTRY %.% " and World Regions in " %.% YEAR)
