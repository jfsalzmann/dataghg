load("data-transf/data_base.RData")

#summarize per capita emissions by country
PDATA$data_inc = data_base %>%
  mutate(dev_status_income = case_when(country=={{COUNTRY}} ~ as.character({{COUNTRY}}),
                                    country!={{COUNTRY}} ~ dev_status_income)) %>% 
  filter(!is.na(dev_status_income)) %>%
  group_by(dev_status_income,country,year,sector_title,pop) %>%
  summarise(GHG_pc_s=sum(GHG_pc,na.rm=TRUE)) %>% # within country: sum
  na.omit() %>%
  group_by(dev_status_income,year,sector_title) %>%
  summarise(GHG_pc_s_r=weighted.mean(GHG_pc_s,pop,na.rm=TRUE)) %>% # across countries: weighted mean
  filter(between(year,{{YEAR_L}},{{YEAR_U}}))


PDATA$data_inc_gdp = data_base %>%
  mutate(dev_status_income = case_when(country=={{COUNTRY}} ~ as.character({{COUNTRY}}),
                                    country!={{COUNTRY}} ~ dev_status_income)) %>% 
  filter(!is.na(dev_status_income)) %>%
  group_by(dev_status_income,country,year,sector_title,gdp_ppp,pop) %>% #!!!! only include pop for na removal consistency; check for gdp na removal effect!
  summarise(GHG_pg_s=sum(GHG_pg,na.rm=TRUE)) %>% # within country: sum
  na.omit() %>%
  group_by(dev_status_income,year,sector_title) %>%
  summarise(GHG_pg_s_r=weighted.mean(GHG_pg_s,gdp_ppp,na.rm=TRUE)) %>% # across countries: weighted mean
  filter(between(year,{{YEAR_L}},{{YEAR_U}}))


PDATA$data_inc_abs = data_base %>%
  mutate(dev_status_income = case_when(country=={{COUNTRY}} ~ as.character({{COUNTRY}}),
                                   country!={{COUNTRY}} ~ dev_status_income)) %>%
  filter(!is.na(dev_status_income)) %>%
  group_by(dev_status_income,country,year,sector_title,pop) %>% # !!!! only include pop for na removal consistency
  summarise(GHG_s=sum(GHG,na.rm=TRUE)) %>% # within country: sum
  na.omit() %>%
  group_by(dev_status_income,year,sector_title) %>%
  summarise(GHG_s_r=sum(GHG_s,na.rm=TRUE)) %>% # across countries: weighted mean
  filter(between(year,{{YEAR_L}},{{YEAR_U}}))


PDATA$data_inc_absavg = data_base %>%
  mutate(dev_status_income = case_when(country=={{COUNTRY}} ~ as.character({{COUNTRY}}),
                                   country!={{COUNTRY}} ~ dev_status_income)) %>%
  filter(!is.na(dev_status_income)) %>%
  group_by(dev_status_income,country,year,sector_title,pop) %>% # !!!! only include pop for na removal consistency
  summarise(GHG_s=sum(GHG,na.rm=TRUE)) %>% # within country: sum
  na.omit() %>%
  group_by(dev_status_income,year,sector_title) %>%
  summarise(GHG_s_r_avg=mean(GHG_s,na.rm=TRUE)) %>% # across countries: weighted mean
  filter(between(year,{{YEAR_L}},{{YEAR_U}}))


PDATA$data_inc_absavg_pc = data_base %>%
  mutate(dev_status_income = case_when(country=={{COUNTRY}} ~ as.character({{COUNTRY}}),
                                   country!={{COUNTRY}} ~ dev_status_income)) %>%
  filter(!is.na(dev_status_income)) %>%
  group_by(dev_status_income,country,year,sector_title,pop,gdp_ppp) %>% # !!!! only include pop for na removal consistency
  summarise(GHG_s=sum(GHG,na.rm=TRUE)) %>% # within country: sum
  na.omit() %>%
  group_by(dev_status_income,year,sector_title) %>%
  summarise(GHG_s_r_avg=weighted.mean(GHG_s,pop,na.rm=TRUE)) %>% # across countries: weighted mean
  filter(between(year,{{YEAR_L}},{{YEAR_U}}))


PDATA$data_absavg_inc_pg = data_base %>%
  mutate(dev_status_income = case_when(country=={{COUNTRY}} ~ as.character({{COUNTRY}}),
                                   country!={{COUNTRY}} ~ dev_status_income)) %>%
  filter(!is.na(dev_status_income)) %>%
  group_by(dev_status_income,country,year,sector_title,pop,gdp_ppp) %>% # !!!! only include pop for na removal consistency
  summarise(GHG_s=sum(GHG,na.rm=TRUE)) %>% # within country: sum
  na.omit() %>%
  group_by(dev_status_income,year,sector_title) %>%
  summarise(GHG_s_r_avg=weighted.mean(GHG_s,gdp_ppp,na.rm=TRUE)) %>% # across countries: weighted mean
  filter(between(year,{{YEAR_L}},{{YEAR_U}}))


PDATA$data_inc_rel = data_base %>%
  mutate(dev_status_income = case_when(country=={{COUNTRY}} ~ as.character({{COUNTRY}}),
                                    country!={{COUNTRY}} ~ dev_status_income)) %>%
  filter(!is.na(dev_status_income)) %>%
  group_by(dev_status_income,country,year,sector_title,pop) %>% # !!!! only include pop for na removal consistency
  summarise(GHG_s=sum(GHG,na.rm=TRUE)) %>% # within country: sum
  na.omit() %>%
  group_by(dev_status_income,year,sector_title) %>%
  summarise(GHG_s_r=sum(GHG_s,na.rm=TRUE)) %>% #across countries: weighted mean
  group_by(dev_status_income,year) %>%
  mutate(GHG_s_r_perc=GHG_s_r/sum(GHG_s_r,na.rm=TRUE)) %>% # 
  filter(between(year,{{YEAR_L}},{{YEAR_U}}))

