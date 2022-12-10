
PDATA$data_base_lp_gdp <-PDATA$data_base_lp_gdp %>% 
  mutate(y=round(y/1e12,2))
# Plot pc
PDATA$p_gdp <- PDATA$data_base_lp_gdp %>% 
  ggplot(., aes(x=x, y=y,label =y)) +
  geom_segment(
    aes(x=x, xend=x, y=0, yend=y), 
    color=case_when(PDATA$data_base_lp_gdp$z == {{COUNTRY}} ~ "red",
                    PDATA$data_base_lp_gdp$z == "EU-27" ~ "blue",
                    PDATA$data_base_lp_gdp$z ==  "United States" ~ "purple",
                    PDATA$data_base_lp_gdp$z %in% c(PDATA$pop_50_gdp$country,PDATA$ghg_50_gdp$country, PDATA$gdp_50_gdp$country) ~ "green",
                    TRUE ~ "grey"),
    size=ifelse(PDATA$data_base_lp_gdp$x  == {{COUNTRY}}, 1.3, 0.7)
  ) +
  geom_point(
    color=case_when(PDATA$data_base_lp_gdp$z == {{COUNTRY}} ~ "red",
                    PDATA$data_base_lp_gdp$z == "EU-27" ~ "blue",
                    PDATA$data_base_lp_gdp$z ==  "United States" ~ "purple",
                    PDATA$data_base_lp_gdp$z %in% c(PDATA$pop_50_gdp$country,ghg_50_gdp$country, gdp_50_gdp$country) ~ "green",
                    TRUE ~ "grey"), 
    size=ifelse(PDATA$data_base_lp_gdp$z  == {{COUNTRY}}, 3, 2)) +
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
  ylab("GDP, ($ Billion US)") +
  ggtitle("Responsibility 4: GDP 2019", subtitle = "Highes GDP, China, US, EU-27 & Reference for GDP, Population and Emissions")

PDATA$p_gdp + annotate("text", x=(which(fct_inorder(PDATA$p_an_gdp)==PDATA$ghg_50_gdp$country)), y=PDATA$data_base_lp_gdp$y[3]*0.8, 
                      label=" ~50 % of global emissions excl. EU-27", 
                      color="black", size=2.5 , angle=0, fontface="italic", vjust =0.4, hjust=-0.2) +
  annotate("text", x=(which(fct_inorder(PDATA$p_an_gdp)==PDATA$gdp_50_gdp$country)), y=PDATA$data_base_lp_gdp$y[3]*0.8, 
           label=" ~50 % of global GDP", 
           color="black", size=2.5 , angle=0, fontface="italic", vjust =0.4, hjust=-0.2) +
  
  annotate("text", x=(which(fct_inorder(PDATA$p_an_gdp)==PDATA$pop_50_gdp$country)), y=PDATA$data_base_lp_gdp$y[3]*0.8, 
           label=" ~50 % of global Population", 
           color="black", size=2.5 , angle=0, fontface="italic", vjust =0.4, hjust=-0.2,) 

