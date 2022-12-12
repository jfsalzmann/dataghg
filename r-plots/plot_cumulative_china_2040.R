OUT = PDATA$data_cumulative_2040 %>%
  ggplot( aes(x=year, y=cumulative, color=country)) +
  geom_line() +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab("Cumulative Emissions (tCO2eq)") +
  theme_ghg()+
  scale_fill_brewer(palette="Set2") +
  theme(axis.title.x = element_blank(),axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ggtitle("Cumulative "%.% GAS %.%" Emissions, Main Scenario, China vs. EU vs. US, "%.% YEAR_L %.%"-" %.% YEAR_U) +
  geom_vline(aes(xintercept = PDATA$is_us[meta_gas_alc[GAS]],color="United States"), show.legend = NA, linetype = "dotted",size=.2) +
  geom_vline(aes(xintercept = PDATA$is_eu[meta_gas_alc[GAS]],color="EU-27"), show.legend = NA,linetype = "dotted",size=.2) +
  scale_x_continuous(breaks=c(seq(1750,2050,by=50),PDATA$is_eu[meta_gas_alc[GAS]],PDATA$is_us[meta_gas_alc[GAS]]))