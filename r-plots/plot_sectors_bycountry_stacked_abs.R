PDATA$data_abs %>% 
  ggplot(aes(x=year,y=GAS_s,fill=sector_title)) +
  geom_area(color="#636363") +
  theme_bw() +
  scale_fill_brewer(palette="Set2") +
  ylab(GAS %.% " Emissions (MtCO2eq)") +
  theme_ghg()+
  theme(axis.title.x=element_blank(),
        text = element_text(size = 25)) +
  guides(fill=guide_legend(title="Sectors"))+
  ggtitle("Total Emissions, " %.% COUNTRY %.% ", by Sector, " %.% YEAR_L %.% "-" %.% YEAR_U)
