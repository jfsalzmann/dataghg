PDATA$data_inc %>%
#  filter(region==c(COUNTRY, "Developed","Developing")) %>% #line breaks
  ggplot( aes(x=year, y=GHG_pc_s_r, color=dev_status_income)) +
  facet_grid(sector_title ~ dev_status_income,scales="free_y") +
  geom_line(show.legend = FALSE) +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab("Per Capita Emissions (tCO2eq)") +
  theme_ghg()+
  theme(axis.title.x = element_blank(),
        text = element_text(size = 7.5),
        axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=0.5)) +
  guides(colour =guide_legend("Income Level /" %.% COUNTRY%.% " " ))+
  ggtitle("Per Capita Emissions " %.% COUNTRY %.% " vs. Income Levels by Sector, 1970-" %.% YEAR_U)

