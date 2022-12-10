

# Plot pc
PDATA$p_abs <- PDATA$data_base_lp_abs %>% 
  ggplot(., aes(x=x, y=y,label =y)) +
  geom_segment(
    aes(x=x, xend=x, y=0, yend=y), 
    color=case_when(PDATA$data_base_lp_abs$z == {{COUNTRY}} ~ "red",
                    PDATA$data_base_lp_abs$z == "EU-27" ~ "blue",
                    PDATA$data_base_lp_abs$z ==  "United States" ~ "purple",
                    PDATA$data_base_lp_abs$z %in% c(PDATA$pop_50_abs$country,PDATA$ghg_50_abs$country, PDATA$gdp_50_abs$country) ~ "green",
                    TRUE ~ "grey"),
    size=ifelse(PDATA$data_base_lp_abs$x  == {{COUNTRY}}, 1.3, 0.7)
  ) +
  geom_point(
    color=case_when(PDATA$data_base_lp_abs$z == {{COUNTRY}} ~ "red",
                    PDATA$data_base_lp_abs$z == "EU-27" ~ "blue",
                    PDATA$data_base_lp_abs$z ==  "United States" ~ "purple",
                    PDATA$data_base_lp_abs$z %in% c(PDATA$pop_50_abs$country,ghg_50_abs$country, gdp_50_abs$country) ~ "green",
                    TRUE ~ "grey"), 
    size=ifelse(PDATA$data_base_lp_abs$z  == {{COUNTRY}}, 3, 2)) +
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
  ylab("GHG Emissions, (Mt. CO2 eq)") +
  ggtitle("Responsibility 1: Absolute Emissions Ranking 2019", subtitle = "Top Emitters, China, US, EU-27 & Reference for GDP, Population and Emissions")

PDATA$p_abs + annotate("text", x=(which(fct_inorder(PDATA$p_an_abs)==PDATA$ghg_50_abs$country)), y=PDATA$data_base_lp_abs$y[2]*0.8, 
                      label=" ~50 % of global emissions", 
                      color="black", size=2.5 , angle=0, fontface="italic", vjust =0.4, hjust=-0) +
  annotate("text", x=(which(fct_inorder(PDATA$p_an_abs)==PDATA$gdp_50_abs$country)), y=PDATA$data_base_lp_abs$y[2]*0.8, 
           label=" ~50 % of global GDP", 
           color="black", size=2.5 , angle=0, fontface="italic", vjust =0.4, hjust=-0) +
  
  annotate("text", x=(which(fct_inorder(PDATA$p_an_abs)==PDATA$pop_50_abs$country)), y=PDATA$data_base_lp_abs$y[2]*0.8, 
           label=" ~50 % of global Population", 
           color="black", size=2.5 , angle=0, fontface="italic", vjust =0.4, hjust=0,) 

PDATA$p_an_abs          
PDATA$p_abs 
fct_inorder(PDATA$p_an_abs)
