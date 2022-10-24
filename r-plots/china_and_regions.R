ggplot(china_and_regions,aes(x=year,y=GHG_pc,fill=region)) +
  geom_area(color="#636363") +              ## Define a colour (grey) to outline each area 
  ylab("Total GHG emissions (GtCO2eq)") +   ## replace the label on the y axis
  theme_bw() +                              ## Use my favourite "black/white" theme 
  scale_fill_brewer(palette="Set2") +       ## Use my favourite color scale from https://colorbrewer2.org
  theme(axis.title.x = element_blank()) +   ## Remove the x axis label (years is obvious)
  ggtitle("Total anthropogenic GHG emissions continue to grow")