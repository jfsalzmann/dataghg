OUT = PDATA$data_comb %>%
  #rbind(data_pred) %>%
  ggplot(aes(x=year, y=diff, color=country)) +
  facet_grid(sector_title~country,scales="free_y") +
  geom_line(aes(linetype = forecast)) +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab("Total Emissions (tCO2eq)") +
  theme_ghg()+
  theme(axis.title.x = element_blank(),axis.text.y=element_blank(),legend.position = "none") +
  ggtitle("Change in Total Emissions and Forecast, China vs. EU vs. US, by Sector, " %.% YEAR_L %.% "-" %.% FYEAR_U)