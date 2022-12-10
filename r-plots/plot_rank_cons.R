PDATA$data_base_lp_con %<>% 
  filter(!is.na(y))
PDATA$p_an_con<-PDATA$p_an_con[-which(PDATA$p_an_con=="United States")]

# Plot pc
PDATA$p_con <- PDATA$data_base_lp_con %>% 
  ggplot(., aes(x=x, y=y,label =y)) +
  geom_segment(
    aes(x=x, xend=x, y=0, yend=y), 
    color=case_when(PDATA$data_base_lp_con$z == {{COUNTRY}} ~ "red",
                    PDATA$data_base_lp_con$z == "EU-27" ~ "blue",
                   # PDATA$data_base_lp_con$z ==  "United States" ~ "purple",
                    PDATA$data_base_lp_con$z %in% c(PDATA$pop_50_con$country,PDATA$ghg_50_con$country, PDATA$gdp_50_con$country) ~ "green",
                    TRUE ~ "grey"),
    size=ifelse(PDATA$data_base_lp_con$x  == {{COUNTRY}}, 1.3, 0.7)
  ) +
  geom_point(
    color=case_when(PDATA$data_base_lp_con$z == {{COUNTRY}} ~ "red",
                    PDATA$data_base_lp_con$z == "EU-27" ~ "blue",
                   # PDATA$data_base_lp_con$z ==  "United States" ~ "purple",
                    PDATA$data_base_lp_con$z %in% c(PDATA$pop_50_con$country,ghg_50_con$country, gdp_50_con$country) ~ "green",
                    TRUE ~ "grey"), 
    size=ifelse(PDATA$data_base_lp_con$z  == {{COUNTRY}}, 3, 2)) +
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
  ylab("CO2 Emissions, (Mt.)") +
  ggtitle("Responsibility 2: Consumption CO2 Emissions Ranking", subtitle = "Top Emitters, China, US, EU-27 & Reference for GDP, Population and Emissions")

PDATA$p_con + annotate("text", x=(which(fct_inorder(PDATA$p_an_con)==PDATA$ghg_50_con$country)), y=PDATA$data_base_lp_con$y[1]*0.8, 
                      label=" ~50 % of global emissions", 
                      color="black", size=2.5 , angle=0, fontface="italic", vjust =0.4, hjust=1) +
  annotate("text", x=(which(fct_inorder(PDATA$p_an_con)==PDATA$gdp_50_con$country)), y=PDATA$data_base_lp_con$y[1]*0.8, 
           label=" ~50 % of global GDP", 
           color="black", size=2.5 , angle=0, fontface="italic", vjust =0.4, hjust=1.25) +
  
  annotate("text", x=(which(fct_inorder(PDATA$p_an_con)==PDATA$pop_50_con$country)), y=PDATA$data_base_lp_con$y[1]*0.8, 
           label=" ~50 % of global Population", 
           color="black", size=2.5 , angle=0, fontface="italic", vjust =0.4, hjust=1) 

PDATA$p_an_con          
PDATA$p_con 
fct_inorder(PDATA$p_an_con)
