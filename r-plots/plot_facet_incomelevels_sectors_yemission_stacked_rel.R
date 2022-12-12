OUT = PDATA$data_inc_rel %>%
#  filter(region==c(COUNTRY, "Developed","Developing")) %>% #line breaks
  ggplot( aes(x = dev_status_income,y=GAS_s_perc, fill=sector_title)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab(GAS %.% " Emissions, %") +
  theme_ghg()+
  scale_x_discrete(guide = guide_axis(n.dodge=2))+
  #scale_fill_brewer(palette="Set2") +
  theme(axis.title.x = element_blank()) +
  geom_text(aes(label = round(GAS_s_perc)), position = position_stack(vjust = 0.5), size = 3) +
  guides(fill =guide_legend("Sector"))+
  ggtitle("Relative Emissions " %.% COUNTRY %.% " vs. Income Levels , by Sector, " %.% YEAR)
if(DIRECT_PLOTTING) plot(OUT)