PDATA$china_and_regions %>%
  filter(region==c(COUNTRY, "Developed Countries","Asia and developing Pacific")) %>% #think about whether another comparison makes sense? 
  ggplot( aes(x=year, y=GHG_pc, group=region, color=region)) +
  geom_line() +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+            
  ylab("Per Capita Emissions (GtCO2eq)") +   
  theme_ghg()+                              
  scale_fill_brewer(palette="Set2") +       
  theme(axis.title.x = element_blank()) +   
  ggtitle("Per Capita Emissions " %.% COUNTRY %.% " vs. Dev' Countries vs. Asia & Dev' Pacific, 1970-" %.% YEAR)

