
#set levels


PDATA$plot_level_kay<-c(COUNTRY,"Developed Countries","Developing Countries")



#plot

OUT<-PDATA$kaya_regions %>%
  mutate(dev_status_reg = fct_relevel(dev_status_reg,PDATA$plot_level_kay)) %>% 
  ggplot(.,aes(x=year,y=value,color=var)) +
  geom_line(size=1) +
  geom_hline(aes(yintercept=1)) +
  facet_wrap(.~dev_status_reg) +
  theme_bw() +
  scale_color_brewer(palette="Set2",labels=c("Carbon intensity (CO2/energy)",
                                             "Carbon emissions",
                                             "Energy intensity (energy/GDP)",
                                             "GDP per capita (GDP/pop)",
                                             "Population"),
                     guide = guide_legend(reverse = TRUE)) +
  scale_y_log10()+
  theme(legend.title=element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=0.5))
if(DIRECT_PLOTTING) plot(OUT)
