OUT = PDATA$data_comb %>%
  #rbind(data_pred) %>%
  ggplot(aes(x=year, y=GAS_s, color=forecast)) +
  facet_wrap(~sector_title,scales="free_y",ncol=1) +
  geom_line(aes(linetype = forecast)) +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab("Total Emissions (tCO2eq)") +
  theme_ghg()+
  theme(axis.title.x = element_blank(),axis.text.y=element_blank(),strip.text.x = element_text(size = 5),legend.position = "none") +
  ggtitle("Total Emissions and Forecast, China, by Sector, " %.% YEAR_L %.% "-" %.% FYEAR_U)