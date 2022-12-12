OUT = PDATA$data_cumulative_2030 %>%
  ggplot( aes(x=year, y=cumulative, color=country)) +
  geom_line() +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab("Cumulative Emissions (tCO2eq)") +
  theme_ghg()+
  scale_fill_brewer(palette="Set2") +
  theme(axis.title.x = element_blank()) +
  ggtitle("Cumulative "%.% GAS %.%" Emissions, Main Scenario, China vs. EU vs. US, "%.% YEAR_L %.%"-" %.% YEAR_U)