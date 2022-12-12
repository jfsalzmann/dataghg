
# Plot pc
OUT <- PDATA$p_gdp_pc <- PDATA$data_base_lp_gdp_pc %>% 
  #mutate(y=round(y,2))%>% 
  ggplot(., aes(x=x, y=y,label =y)) +
  geom_segment(
    aes(x=x, xend=x, y=0, yend=y), 
    color=case_when(PDATA$data_base_lp_gdp_pc$z == {{COUNTRY}} ~ "red",
                    PDATA$data_base_lp_gdp_pc$z == "EU-27" ~ "blue",
                    PDATA$data_base_lp_gdp_pc$z ==  "United States" ~ "purple",
                    PDATA$data_base_lp_gdp_pc$z %in% c(PDATA$pop_50_gdp_pc$country,PDATA$ghg_50_gdp_pc$country, PDATA$gdp_50_gdp_pc$country) ~ "green",
                    TRUE ~ "grey"),
    size=ifelse(PDATA$data_base_lp_gdp_pc$z  == {{COUNTRY}}, 1.3, 0.7)
  ) +
  geom_point(
    color=case_when(PDATA$data_base_lp_gdp_pc$z == {{COUNTRY}} ~ "red",
                    PDATA$data_base_lp_gdp_pc$z == "EU-27" ~ "blue",
                    PDATA$data_base_lp_gdp_pc$z ==  "United States" ~ "purple",
                    PDATA$data_base_lp_gdp_pc$z %in% c(PDATA$pop_50_gdp_pc$country,ghg_50_gdp_pc$country, gdp_50_gdp_pc$country) ~ "green",
                    TRUE ~ "grey"), 
    size=ifelse(PDATA$data_base_lp_gdp_pc$z  == {{COUNTRY}}, 3, 2)) +
  geom_text(
    nudge_x = 0.25, nudge_y = 0.25, size= 2.5, 
    check_overlap = T
  )+
  theme_ghg() +
  coord_flip() +
  theme(
    legend.position="none"
  ) +
  xlab("") +
  ylab("GDP per Capita, ($ 1000 US)") +

  ggtitle("Responsibility 5: GDP per Capita  2019", subtitle = "Highest GDP per Capita, China, US, EU-27 & Reference for GDP, Population and Emissions")+
 annotate("text", x=(which(fct_inorder(PDATA$p_an_gdp_pc)==PDATA$ghg_50_gdp_pc$country)), y=PDATA$data_base_lp_gdp_pc$y[3]*0.8, 
                       label=" ~50 % of global emissions", 
                       color="black", size=2.5 , angle=0, fontface="italic", vjust =0.4, hjust=-0.2) +
  annotate("text", x=(which(fct_inorder(PDATA$p_an_gdp_pc)==PDATA$gdp_50_gdp_pc$country)), y=PDATA$data_base_lp_gdp_pc$y[3]*0.8, 
           label=" ~50 % of global GDP", 
           color="black", size=2.5 , angle=0, fontface="italic", vjust =0.4, hjust=-0.2) +
  
  annotate("text", x=(which(fct_inorder(PDATA$p_an_gdp_pc)==PDATA$pop_50_gdp_pc$country)), y=PDATA$data_base_lp_gdp_pc$y[3]*0.8, 
           label=" ~50 % of global Population", 
           color="black", size=2.5 , angle=0, fontface="italic", vjust =0.4, hjust=-0.2,) 
 if(DIRECT_PLOTTING) plot(OUT)
 
