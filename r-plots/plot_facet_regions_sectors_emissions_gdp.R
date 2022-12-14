PDATA$data_gdp %>%
#  filter(region==c(COUNTRY, "Developed","Developing")) %>% #line breaks
  ggplot( aes(x=year, y=GHG_pg_s_r, color=region)) +
  facet_grid(sector_title ~ region,scales="free_y") +
  geom_line() +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab("Per GDP Emissions (tCO2eq)") +
  theme_ghg()+
  scale_fill_brewer(palette="Set2") +
  theme(axis.title.x = element_blank()) +
  ggtitle("Per GDP Emissions " %.% COUNTRY %.% " vs. Developed/Developing Countries by Sector, 1970-" %.% YEAR_U)

