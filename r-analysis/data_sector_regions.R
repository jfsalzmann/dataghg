load("data-transf/data_base.RData")

#summarize per capita emissions by country
PDATA$data = data_base %>%
  mutate(region = case_when(deving_woc ~ "Developing",country == {{COUNTRY}} ~ {{COUNTRY}},deved ~ "Developed")) %>%
  filter(!is.na(region)) %>%
  group_by(region,country,year,sector_title,pop) %>%
  summarise(GHG_pc_s=sum(GHG_pc,na.rm=TRUE)) %>% # within country: sum
  na.omit() %>%
  group_by(region,year,sector_title) %>%
  summarise(GHG_pc_s_r=weighted.mean(GHG_pc_s,pop,na.rm=TRUE)) %>% # across countries: weighted mean
  filter(between(year,{{YEAR_L}},{{YEAR_U}}))
