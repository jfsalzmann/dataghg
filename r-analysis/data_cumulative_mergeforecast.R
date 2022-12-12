load("data-transf/data_cghg_1750_2019.RData")
data = data_cghg_1750_2019

load("data-transf/forecast_GHG_2040.RData")
fdata_2040_ghg = forecast %>%
  mutate(country = ifelse(country == "EU","EU-27",country)) %>%
  filter(year > 2019) %>%
  group_by(country,year) %>%
  summarise(GAS_ss = sum(GAS_s)) %>%
  rename(GHG = GAS_ss) %>%
  mutate(cum_ghg = NA)

load("data-transf/forecast_CO2_2040.RData")
fdata_2040_co2 = forecast %>%
  mutate(country = ifelse(country == "EU","EU-27",country)) %>%
  filter(year > 2019) %>%
  group_by(country,year) %>%
  summarise(GAS_ss = sum(GAS_s)) %>%
  rename(co2 = GAS_ss) %>%
  mutate(cum_co2 = NA)

fdata_2040 = fdata_2040_ghg %>%
  left_join(fdata_2040_co2)

load("data-transf/forecast_GHG_2030.RData")
fdata_2030_ghg = forecast %>%
  mutate(country = ifelse(country == "EU","EU-27",country)) %>%
  filter(year > 2019) %>%
  group_by(country,year) %>%
  summarise(GAS_ss = sum(GAS_s)) %>%
  rename(GHG = GAS_ss) %>%
  mutate(cum_ghg = NA)

load("data-transf/forecast_CO2_2030.RData")
fdata_2030_co2 = forecast %>%
  mutate(country = ifelse(country == "EU","EU-27",country)) %>%
  filter(year > 2019) %>%
  group_by(country,year) %>%
  summarise(GAS_ss = sum(GAS_s)) %>%
  rename(co2 = GAS_ss) %>%
  mutate(cum_co2 = NA)

fdata_2030 = fdata_2030_ghg %>%
  left_join(fdata_2030_co2)

data_2040 = data %>% rbind(fdata_2040) %>%
  arrange(year) %>% 
  group_by(country) %>% 
  mutate(cum_ghg = cumsum(coalesce(GHG, 0)) + GHG*0,
         cum_co2 = cumsum(coalesce(co2, 0)) + co2*0)

data_2040 %>% write.xlsx("data-transf/data_cumulative_2040.xlsx", asTable = FALSE, overwrite = TRUE)

data_2030 = data %>% rbind(fdata_2030) %>%
  arrange(year) %>% 
  group_by(country) %>% 
  mutate(cum_ghg = cumsum(coalesce(GHG, 0)) + GHG*0,
         cum_co2 = cumsum(coalesce(co2, 0)) + co2*0)

data_2030 %>% write.xlsx("data-transf/data_cumulative_2030.xlsx", asTable = FALSE, overwrite = TRUE)


data_2040 %<>% select(-co2,-GHG) %>%
  rename(GHG = cum_ghg, CO2 = cum_co2) %>%
  gather(key = "gas", value="cumulative",-country,-year) %>%
  filter(gas == {{GAS}} & between(year,{{YEAR_L}},{{YEAR_U}}))

data_2030 %<>% select(-co2,-GHG) %>%
  rename(GHG = cum_ghg, CO2 = cum_co2) %>%
  gather(key = "gas", value="cumulative",-country,-year) %>%
  filter(gas == {{GAS}} & between(year,{{YEAR_L}},{{YEAR_U}}))

PDATA$is_us = c(2038,NA,NA,NA,2032)
PDATA$is_eu = c(2031,NA,NA,NA,2027)

PDATA$data_cumulative_2040 = data_2040
PDATA$data_cumulative_2030 = data_2030
