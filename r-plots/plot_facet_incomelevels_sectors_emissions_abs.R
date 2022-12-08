PDATA$data_inc_abs %>%
#  filter(region==c(COUNTRY, "Developed","Developing")) %>% #line breaks
  ggplot( aes(x=year, y=GHG_s_r, color=dev_status_income)) +
  facet_wrap(sector_title ~ dev_status_income,scales="free_y",nrow=length(unique(PDATA$data_abs$sector_title))) +
  geom_line() +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab("Total Emissions (tCO2eq)") +
  theme_ghg()+
  guides(colour =guide_legend("Income Level /" %.% COUNTRY%.% " " ))+
  
  theme(axis.title.x = element_blank(),strip.text.x = element_text(size = 5)) +
  ggtitle("Total Emissions " %.% COUNTRY %.% " vs. Income Levels by Sector, 1970-" %.% YEAR_U)
