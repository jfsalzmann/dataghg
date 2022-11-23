PDATA$data %>%
#  filter(region==c(COUNTRY, "Developed","Developing")) %>% #line breaks
  ggplot( aes(x=year, y=GHG_pc_s_r, color=region)) +
  facet_grid(sector_title ~ region,scales="free_y") +
  geom_line(show.legend = FALSE) +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab("Per Capita Emissions (tCO2eq)") +
  theme_ghg()+
  scale_fill_brewer(palette="Set2") +
  theme(axis.title.x = element_blank(),
        text = element_text(size = 14),
        axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=0.5)) +
  ggtitle("Per Capita Emissions " %.% COUNTRY %.% " vs. \nDeveloped/Developing Countries by Sector, 1970-" %.% YEAR_U)

