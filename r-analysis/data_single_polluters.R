load("data-transf/data_base.RData")


PDATA$data_abs = data_base %>%
  mutate(region = case_when(country == {{COUNTRY}} ~ {{COUNTRY}},
                            EU ~ "EU-28",
                            country %in% c("United States","China","India","Russian Federation") ~ country,
                            TRUE ~ "Other")) %>%
  rename(GAS := {{GAS}}) %>%
  group_by(year,region) %>%
  summarise(GAS_s=sum(GAS,na.rm=TRUE)) %>%
  na.omit() %>%
  filter(between(year,{{YEAR_L}},{{YEAR_U}}))



PDATA$data_rel = data_base %>%
  mutate(region = case_when(country == {{COUNTRY}} ~ {{COUNTRY}},
                            EU ~ "EU-28",
                            country %in% c("United States","China","India","Russian Federation") ~ country,
                            TRUE ~ "Other")) %>%
  rename(GAS := {{GAS}}) %>%
  group_by(year,region) %>%
  summarise(GAS_s=sum(GAS,na.rm=TRUE)) %>%
  na.omit() %>%
  filter(between(year,{{YEAR_L}},{{YEAR_U}})) %>%
  group_by(year) %>%
  mutate(GAS_s_perc=100*GAS_s/sum(GAS_s,na.rm=TRUE))





# 
# PDATA$data_rel = data_base %>%
#   mutate(region = case_when(deving_woc ~ "Developing",country == {{COUNTRY}} ~ {{COUNTRY}},deved ~ "Developed")) %>%
#   filter(!is.na(region)) %>%
#   group_by(region,country,year,sector_title,pop) %>% # !!!! only include pop for na removal consistency
#   summarise(GHG_s=sum(GHG,na.rm=TRUE)) %>% # within country: sum
#   na.omit() %>%
#   group_by(region,year,sector_title) %>%
#   summarise(GHG_s_r=sum(GHG_s,na.rm=TRUE)) %>% #across countries: weighted mean
#   group_by(region,year) %>%
#   mutate(GHG_s_r_perc=GHG_s_r/sum(GHG_s_r,na.rm=TRUE)) %>% # 
#   filter(between(year,{{YEAR_L}},{{YEAR_U}}))