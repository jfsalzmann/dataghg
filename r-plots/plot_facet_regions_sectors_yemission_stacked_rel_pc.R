PDATA$data_rel_pc %>%
#  filter(region==c(COUNTRY, "Developed","Developing")) %>% #line breaks
  ggplot( aes(x = region,y=GAS_s_perc, fill=sector_title)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab(GAS %.% " Emissions, %") +
  theme_ghg()+
  #scale_fill_brewer(palette="Set2") +
  theme(axis.title.x = element_blank(),
        text = element_text(size = 20))+
  guides(fill=guide_legend(title="Country/Region"))+
  ggtitle("Relative Emissions " %.% COUNTRY %.% " vs. pc-Avg'ed Developed/Developing Countries, by Sector, " %.% YEAR)
