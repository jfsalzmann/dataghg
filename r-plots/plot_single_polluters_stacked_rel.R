PDATA$data_rel %>% 
  ggplot(aes(x=year,y=GAS_s_perc,fill=region)) +
  geom_area(color="#636363") +
  theme_bw() +
  scale_fill_brewer(palette="Set2") +
  ylab(GAS %.% " Emissions, %") +
  theme_ghg()+
  theme(axis.title.x=element_blank()) +
  ggtitle("Relative Emissions, " %.% COUNTRY %.% " vs. Dev'ed/Dev'ing Countries by Sector, " %.% YEAR_L %.% "-" %.% YEAR_U)