load("data-transf/data_base.RData")


PDATA$data_rel = data_base %>%
  mutate(region = case_when(deving_woc ~ "Developing",country == {{COUNTRY}} ~ {{COUNTRY}},deved ~ "Developed")) %>%
  filter(!is.na(region)) %>%
  rename(GAS := {{GAS}}) %>%
  na.omit() %>% # !!
  filter(year == {{YEAR}}) %>%
  group_by(region,sector_title) %>%
  summarise(GAS_s=sum(GAS,na.rm=TRUE)) %>%
  group_by(region) %>%
  mutate(GAS_s_perc=100*GAS_s/sum(GAS_s,na.rm=TRUE))


PDATA$data_rel_pc = data_base %>%
  mutate(region = case_when(deving_woc ~ "Developing",country == {{COUNTRY}} ~ {{COUNTRY}},deved ~ "Developed")) %>%
  filter(!is.na(region)) %>%
  rename(GAS := {{GAS}}) %>%
  na.omit() %>% # !!
  filter(year == {{YEAR}}) %>%
  group_by(region,sector_title) %>%
  summarise(GAS_s=weighted.mean(GAS,pop,na.rm=TRUE)) %>%
  group_by(region) %>%
  mutate(GAS_s_perc=100*GAS_s/sum(GAS_s,na.rm=TRUE))


PDATA$data_rel_pg = data_base %>%
  mutate(region = case_when(deving_woc ~ "Developing",country == {{COUNTRY}} ~ {{COUNTRY}},deved ~ "Developed")) %>%
  filter(!is.na(region)) %>%
  rename(GAS := {{GAS}}) %>%
  na.omit() %>% # !!
  filter(year == {{YEAR}}) %>%
  group_by(region,sector_title) %>%
  summarise(GAS_s=weighted.mean(GAS,gdp_ppp,na.rm=TRUE)) %>%
  group_by(region) %>%
  mutate(GAS_s_perc=100*GAS_s/sum(GAS_s,na.rm=TRUE))



# PDATA$data_rel_pc = data_base %>%
#   mutate(region = case_when(deving_woc ~ "Developing",country == {{COUNTRY}} ~ {{COUNTRY}},deved ~ "Developed")) %>%
#   filter(!is.na(region)) %>%
#   rename(GAS := {{GAS}}) %>%
#   na.omit() %>% # !!
#   filter(year == {{YEAR}}) %>%
#   group_by(region,sector_title) %>%
#   summarise(GAS_s=sum(GAS,na.rm=TRUE)) %>%
#   group_by(year) %>%
#   mutate(GAS_s_perc=100*GAS_s/sum(GAS_s,na.rm=TRUE))
# 
# 
# 
# PDATA$data_rel_pg = data_base %>%
#   mutate(region = case_when(deving_woc ~ "Developing",country == {{COUNTRY}} ~ {{COUNTRY}},deved ~ "Developed")) %>%
#   filter(!is.na(region)) %>%
#   rename(GAS := {{GAS}}) %>%
#   na.omit() %>% # !!
#   filter(year == {{YEAR}}) %>%
#   group_by(region,sector_title) %>%
#   summarise(GAS_s=sum(GAS,na.rm=TRUE)) %>%
#   group_by(year) %>%
#   mutate(GAS_s_perc=100*GAS_s/sum(GAS_s,na.rm=TRUE))