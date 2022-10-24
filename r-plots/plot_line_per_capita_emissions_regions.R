country_and_regions %>%
  filter(region==c(COUNTRY, "Developed Countries","Asia and developing Pacific")) %>% #line breaks 
  ggplot( aes(x=year, y=GHG_pc, group=region, color=region)) +
  geom_line() +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+            
  ylab("Per Capita Emissions (tCO2eq)") +   
  theme_ghg()+                              
  scale_fill_brewer(palette="Set2") +       
  theme(axis.title.x = element_blank()) +   
  ggtitle("Per Capita Emissions " %.% COUNTRY %.% " vs. Developed Countries vs. Asia & Developing Pacific, 1970-" %.% YEAR)

