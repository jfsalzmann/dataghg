PDATA$data_rel_pg %>%
#  filter(region==c(COUNTRY, "Developed","Developing")) %>% #line breaks
  ggplot( aes(x = region,y=GAS_s_perc, fill=sector_title)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab(GAS %.% " Emissions, %") +
  theme_ghg()+
  #scale_fill_brewer(palette="Set2") +
  theme(axis.title.x = element_blank()) +
  ggtitle("Relative Emissions " %.% COUNTRY %.% " vs. pg-Avg'ed Developed/Developing Countries, by Sector, " %.% YEAR)
