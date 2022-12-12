OUT = PDATA$data_rel %>% 
  ggplot(aes(x=year,y=GAS_s_perc,fill=region)) +
  geom_area(color="#636363") +
  geom_vline(xintercept= 2004, linetype="dotted",color = "red")+
  theme_bw() +
  scale_fill_brewer(palette="Set2") +
  ylab(GAS %.% " Emissions, %") +
  theme_ghg()+
  theme(axis.title.x=element_blank()) +
  guides(fill = guide_legend("Region") )+
  ggtitle("Relative Emissions of the Top- 5 Polluters " %.% YEAR_L %.% "-" %.% YEAR_U)
if(DIRECT_PLOTTING) plot(OUT)
  

