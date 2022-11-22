load("data-transf/data_hist_co2.RData")


#Hard setting yearL
YEAR_L<-1850

data_cum_co2 = data_hist_co2 %>%
  select(ISO, country, EU,  year, CO2_FFI) %>% 
  mutate(region = case_when(country == {{COUNTRY}} ~ {{COUNTRY}},
                            EU ~ "EU-28",
                            ISO %in% c("USA","CHN","IND","RUS") ~ country,
                            TRUE ~ "Other")) %>% 
  mutate(CO2_FFI=replace_na(CO2_FFI, 0)) %>% 
  group_by(region,year) %>% 
  summarise(CO2=sum(CO2_FFI)) %>%
  mutate(cum_CO2=cumsum(CO2)) %>%
  filter(between(year,{{YEAR_L}},{{YEAR_U}})) %>% 
  group_by(year) %>%
  mutate(cum_CO2_perc=100*round(cum_CO2/sum(cum_CO2,na.rm=TRUE),4))


# testing plots 

data_cum_co2 %>% 
  ggplot(aes(x=year,y=cum_CO2,color=region)) +
  geom_line(size=1)  +
  theme_bw() +
  scale_fill_brewer(palette="Set2") +
  ylab("Cumulative CO2 Emissions (MtCO2)") +
  theme_ghg()+
  theme(axis.title.x=element_blank(),
        text = element_text(size = 20)) +
  guides(color=guide_legend(title="Country"))+
  ggtitle("Cumulative CO2 " %.% COUNTRY %.% " vs. Top Emitters, " %.% YEAR_L %.% "-" %.% YEAR_U)


data_cum_co2 %>% 
  ggplot(aes(x=year,y=cum_CO2_perc,fill=region)) +
  geom_area(color="#636363") +
  theme_bw() +
  scale_fill_brewer(palette="Set2") +
  ylab("Cumulative CO2 Emissions, %") +
  theme_ghg()+
  theme(axis.title.x=element_blank(),
        text = element_text(size = 20)) +
  guides(fill=guide_legend(title="Country/Region"))+
  ggtitle("Relative Cumulative Emissions of the Top- 5 Polluters " %.% YEAR_L %.% "-" %.% YEAR_U)



data_cum_co2 %>% 
  ggplot(aes(x=year,y=CO2,color=region)) +
  geom_line(size=1)  +
  theme_bw() +
  scale_fill_brewer(palette="Set2") +
  ylab("CO2 Emissions (MtCO2)") +
  theme_ghg()+
  theme(axis.title.x=element_blank(),
        text = element_text(size = 20)) +
  guides(color=guide_legend(title="Country/Region"))+
  ggtitle("Absolute Yearly Emissions of the Top- 5 Polluters " %.% YEAR_L %.% "-" %.% YEAR_U)
