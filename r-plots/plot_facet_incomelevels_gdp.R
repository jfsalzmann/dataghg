PDATA$data_inc_gdp %>%
  mutate(GHG_pg_s_r=GHG_pg_s_r*1000) %>% 
  #  filter(region==c(COUNTRY, "Developed","Developing")) %>% #line breaks
  ggplot( aes(x=year, y=GHG_pg_s_r, color=dev_status_income)) +
  facet_grid(sector_title ~ dev_status_income,scales="free_y") +
  geom_line() +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab("Per GDP Emissions (tCO2eq/1000$)") +
  theme_ghg()+
  scale_fill_brewer(palette="Set2") +
  theme(axis.title.x = element_blank(),
        text = element_text(size = 6),
        axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=0.5)) +
  guides(colour =guide_legend("Income Level /" %.% COUNTRY%.% " " ))+
  ggtitle("Per GDP Emissons " %.% COUNTRY %.% " vs. Income Levels by Sector, 1970-" %.% YEAR_U)
