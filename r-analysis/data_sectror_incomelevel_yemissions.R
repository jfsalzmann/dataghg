load("data-transf/data_base.RData")


PDATA$data_inc_rel = data_base %>%
  mutate(dev_status_income = case_when(country=={{COUNTRY}} ~ as.character({{COUNTRY}}),
                                       country!={{COUNTRY}} ~ dev_status_income)) %>% 
  filter(!is.na(dev_status_income)) %>%
  rename(GAS := {{GAS}}) %>%
  na.omit() %>% # !!
  filter(year == {{YEAR}}) %>%
  group_by(dev_status_income,sector_title) %>%
  summarise(GAS_s=sum(GAS,na.rm=TRUE)) %>%
  group_by(dev_status_income) %>%
  mutate(GAS_s_perc=100*GAS_s/sum(GAS_s,na.rm=TRUE))


PDATA$data_inc_rel_pc = data_base %>%
  mutate(dev_status_income = case_when(country=={{COUNTRY}} ~ as.character({{COUNTRY}}),
                                       country!={{COUNTRY}} ~ dev_status_income)) %>% 
  filter(!is.na(dev_status_income)) %>%
  rename(GAS := {{GAS}}) %>%
  na.omit() %>% # !!
  filter(year == {{YEAR}}) %>%
  group_by(dev_status_income,sector_title) %>%
  summarise(GAS_s=weighted.mean(GAS,pop,na.rm=TRUE)) %>%
  group_by(dev_status_income) %>%
  mutate(GAS_s_perc=100*GAS_s/sum(GAS_s,na.rm=TRUE))


PDATA$data_inc_rel_pg = data_base %>%
  mutate(dev_status_income = case_when(country=={{COUNTRY}} ~ as.character({{COUNTRY}}),
                                       country!={{COUNTRY}} ~ dev_status_income)) %>% 
  filter(!is.na(dev_status_income)) %>%
  rename(GAS := {{GAS}}) %>%
  na.omit() %>% # !!
  filter(year == {{YEAR}}) %>%
  group_by(dev_status_income,sector_title) %>%
  summarise(GAS_s=weighted.mean(GAS,gdp_ppp,na.rm=TRUE)) %>%
  group_by(dev_status_income) %>%
  mutate(GAS_s_perc=100*GAS_s/sum(GAS_s,na.rm=TRUE))



# PDATA$data_rel_pc = data_base %>%
#   mutate(dev_status_income = case_when(deving_woc ~ "Developing",country == {{COUNTRY}} ~ {{COUNTRY}},deved ~ "Developed")) %>%
#   filter(!is.na(dev_status_income)) %>%
#   rename(GAS := {{GAS}}) %>%
#   na.omit() %>% # !!
#   filter(year == {{YEAR}}) %>%
#   group_by(dev_status_income,sector_title) %>%
#   summarise(GAS_s=sum(GAS,na.rm=TRUE)) %>%
#   group_by(year) %>%
#   mutate(GAS_s_perc=100*GAS_s/sum(GAS_s,na.rm=TRUE))
# 
# 
# 
# PDATA$data_rel_pg = data_base %>%
#   mutate(dev_status_income = case_when(deving_woc ~ "Developing",country == {{COUNTRY}} ~ {{COUNTRY}},deved ~ "Developed")) %>%
#   filter(!is.na(dev_status_income)) %>%
#   rename(GAS := {{GAS}}) %>%
#   na.omit() %>% # !!
#   filter(year == {{YEAR}}) %>%
#   group_by(dev_status_income,sector_title) %>%
#   summarise(GAS_s=sum(GAS,na.rm=TRUE)) %>%
#   group_by(year) %>%
#   mutate(GAS_s_perc=100*GAS_s/sum(GAS_s,na.rm=TRUE))