
PDATA$plot_level_kay<-c(COUNTRY,"Low income","Lower middle-income","Upper middle-income","High income")


OUT<-PDATA$kaya_incomelevels %>%
  mutate(region = fct_relevel(dev_status_income,PDATA$plot_level_kay)) %>% 
  filter(dev_status_income== "China") %>% 
  ggplot(.,aes(x=year,y=value,color=var)) +
  geom_line(size=1) +
  geom_hline(aes(yintercept=1)) +
  facet_wrap(.~region) +
  theme_bw() +
  scale_y_log10()+
  scale_color_brewer(palette="Set2",labels=c("Carbon intensity (CO2/energy)",
                                             "Carbon emissions",
                                             "Energy intensity (energy/GDP)",
                                             "GDP per capita (GDP/pop)",
                                             "Population"),
                     guide = guide_legend(reverse = TRUE)) +
  theme(legend.title=element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank())
if(DIRECT_PLOTTING) plot(OUT)

OUT
