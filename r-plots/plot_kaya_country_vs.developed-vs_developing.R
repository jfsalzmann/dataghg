#plot

PDATA$kaya_regions %>% 
  ggplot(.,aes(x=year,y=value,color=var)) +
  geom_line(size=1) +
  geom_hline(aes(yintercept=1)) +
  facet_wrap(.~region) +
  theme_bw() +
  scale_color_brewer(palette="Set2",labels=c("Carbon intensity (CO2/energy)",
                                             "Carbon emissions",
                                             "Energy intensity (energy/GDP)",
                                             "GDP per capita (GDP/pop)",
                                             "Population"),
                     guide = guide_legend(reverse = TRUE)) +
  theme(legend.title=element_blank(),
        axis.title.x = element_blank())