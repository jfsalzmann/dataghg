#set levels

# plot_level<-PDATA$country_and_regions %>%
#   filter(region!={{COUNTRY}}) %>%
#   arrange(desc(GHG_pc)) %>%
#   pull(region)
# 
# plot_level<-c(COUNTRY,plot_level)

#plot

# ,levels=plot_level

PDATA$country_and_regions %>%
  ggplot(., aes(y=GHG_pc,x=factor(region), fill=as.factor(region) )) +
  geom_bar( stat = 'identity') +
  scale_fill_brewer(palette = "Set1") +
  theme(legend.position="none")+
  ylab("Percapita Emissions (tCO2eq)") +
  theme_ghg()+
  scale_fill_brewer(palette="Set1") +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_text(angle = 45, vjust = 1, hjust=1),
        legend.position="none") +
  ggtitle("Per Capita Emissions " %.% COUNTRY %.% " and World Regions in " %.% YEAR)
