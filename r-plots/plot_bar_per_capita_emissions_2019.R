china_and_regions %>%
  filter(year==2019) %>%
  ggplot(., aes(y=GHG_pc,x=factor(region,levels=level), fill=as.factor(region) )) + 
  geom_bar( stat = 'identity') +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+             
  ylab("Percapita Emissions (GtCO2eq)") +   
  theme_ghg()+                               
  scale_fill_brewer(palette="Set2") +       
  theme(axis.title.x = element_blank()) +   
  ggtitle("Per Capita Emissions China and World Regions in 2019 ")