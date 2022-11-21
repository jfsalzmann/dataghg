PDATA$data_absavg_pg %>%
#  filter(region==c(COUNTRY, "Developed","Developing")) %>% #line breaks
  ggplot( aes(x=year, y=GHG_s_r_avg, color=region)) +
  facet_grid(sector_title ~ region,scales="free_y") +
  geom_line() +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab("Avg Total Emissions (tCO2eq)") +
  theme_ghg()+
  scale_fill_brewer(palette="Set2") +
  theme(axis.title.x = element_blank()) +
  ggtitle("Absolute Emissions " %.% COUNTRY %.% " vs. pc-Avg'ed Developed/Developing Countries by Sector, 1970-" %.% YEAR_U)
