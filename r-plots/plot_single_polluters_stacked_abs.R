PDATA$data_abs %>% 
  ggplot(aes(x=year,y=GAS_s,fill=region)) +
  geom_area(color="#636363") +
  theme_bw() +
  scale_fill_brewer(palette="Set2") +
  ylab(GAS %.% " Emissions (MtCO2eq)") +
  theme_ghg()+
  theme(axis.title.x=element_blank()) +
  ggtitle("Total Emissions " %.% COUNTRY %.% " vs. Dev'ed/Dev'ing Countries by Sector, " %.% YEAR_L %.% "-" %.% YEAR_U)