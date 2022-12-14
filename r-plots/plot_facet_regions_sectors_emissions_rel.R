PDATA$data_rel %>%
#  filter(region==c(COUNTRY, "Developed","Developing")) %>% #line breaks
  ggplot( aes(x=year, y=GHG_s_r_perc, color=region)) +
  facet_grid(sector_title ~ region,scales="free_y") +
  geom_line() +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab("Relative Emissions %") +
  theme_ghg()+
  scale_fill_brewer(palette="Set2") +
  theme(axis.title.x = element_blank()) +
  ggtitle("Relative Emissions " %.% COUNTRY %.% " vs. Developed/Developing Countries by Sector, 1970-" %.% YEAR_U)
