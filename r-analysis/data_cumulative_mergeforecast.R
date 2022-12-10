load("data-transf/data_cghg_1750_2019.RData")
data = data_cghg_1750_2019

load("data-transf/forecast_GHG_2040.RData")
fdata_2040 = forecast %>%
  mutate(country = ifelse(country == "EU","EU-27",country)) %>%
  filter(year > 2019) %>%
  group_by(country,year) %>%
  summarise(GAS_ss = sum(GAS_s)) %>%
  rename(GHG = GAS_ss) %>%
  mutate(cum_ghg = NA)

load("data-transf/forecast_GHG_2030.RData")
fdata_2030 = forecast %>%
  mutate(country = ifelse(country == "EU","EU-27",country)) %>%
  filter(year > 2019) %>%
  group_by(country,year) %>%
  summarise(GAS_ss = sum(GAS_s)) %>%
  rename(GHG = GAS_ss) %>%
  mutate(cum_ghg = NA)

data_2040 = data %>% rbind(fdata_2040) %>%
  arrange(year) %>% 
  group_by(country) %>% 
  mutate(cum_ghg = cumsum(coalesce(GHG, 0)) + GHG*0)

data_2040 %>% write.xlsx("data-transf/data_cumulative_2040.xlsx", asTable = FALSE, overwrite = TRUE)
PDATA$data_2040 = data_2040

data_2030 = data %>% rbind(fdata_2030) %>%
  arrange(year) %>% 
  group_by(country) %>% 
  mutate(cum_ghg = cumsum(coalesce(GHG, 0)) + GHG*0)

data_2030 %>% write.xlsx("data-transf/data_cumulative_2030.xlsx", asTable = FALSE, overwrite = TRUE)
PDATA$data_2030 = data_2030