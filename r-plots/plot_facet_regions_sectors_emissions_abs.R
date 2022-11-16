PDATA$data_abs %>%
#  filter(region==c(COUNTRY, "Developed","Developing")) %>% #line breaks
  ggplot( aes(x=year, y=GHG_s_r, color=region)) +
  facet_wrap(sector_title ~ region,scales="free_y",nrow=length(unique(PDATA$data_abs$sector_title))) +
  geom_line() +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab("Per Capita Emissions (tCO2eq)") +
  theme_ghg()+
  scale_fill_brewer(palette="Set2") +
  theme(axis.title.x = element_blank(),axis.text.y=element_blank(),strip.text.x = element_text(size = 5)) +
  ggtitle("Total Emissions " %.% COUNTRY %.% " vs. Developed/Developing Countries by Sector, 1970-" %.% YEAR_U)
