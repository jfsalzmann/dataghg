load("data-transf/data_base.RData")
library(imputeTS)

years = 2020:2029
sectors = c("Buildings","Transport","AFOLU","Energy systems","Industry")
oos_end = expand.grid(year = c(2030), sector_title = sectors) %>% mutate(GAS_s = NA, diff = 0)
oos = expand.grid(year = years,sector_title = sectors) %>% mutate(GAS_s = NA, diff = NA) %>% rbind(oos_end)


data = data_base %>%
  filter(country == "China") %>%
  rename(GAS := "CO2") %>%
  group_by(year,sector_title) %>%
  summarise(GAS_s=sum(GAS,na.rm=TRUE)) %>%
  na.omit() %>%
  filter(
      sector_title %in% c("Buildings","Transport") & between(year,2009,2019) |
      sector_title %in% c("AFOLU","Energy systems") & between(year,2009,2019) |
        sector_title %in% c("Industry") & between(year,1999,2019)
  ) %>% 
  group_by(sector_title) %>%
  mutate(diff = GAS_s - lag(GAS_s, default = first(GAS_s), order_by = year)) %>%
  filter(diff != 0)


data_ext = data %>% 
  rbind(oos) %>% 
  group_by(sector_title) %>%
  mutate(diff = na_interpolation(diff)) %>%
  filter(year>=2019) %>%
  mutate(GAS_s = ifelse(is.na(GAS_s),max(GAS_s,na.rm = T) + accumulate(diff,sum),GAS_s)) %>%
  filter(year != 2019)




data_pred = data %>%
  nest() %>%
  mutate(
    model = map(data, ~lm(log(GAS_s)~year, data = .)),
    param = map(model, broom::tidy),
    oos = list(tibble(year = 2020:2060)),
    pred = map2(model,oos,~broom::augment(.x,newdata=.y)),
    pred = map(pred,~.x %>% rename(GAS_s := .fitted) %>% mutate(GAS_s = exp(GAS_s)))
  ) %>% 
  select(sector_title,pred) %>%
  unnest(cols=c("pred"))


data_double = data_ext %>%
  filter(year == 2020) %>% 
  mutate(forecast = F)

data_comb = data %>%
  rbind(data_ext) %>%
  mutate(forecast = ifelse(year <= 2019,F,T)) %>%
  rbind(data_double)


data_comb %>%
  #rbind(data_pred) %>%
  ggplot(aes(x=year, y=GAS_s, color=forecast)) +
    facet_wrap(~sector_title,scales="free_y",ncol=1) +
    geom_line() +
    scale_fill_brewer(palette = "Set2") +
    theme(legend.position="none")+
    ylab("Total Emissions (tCO2eq)") +
    theme_ghg()+
    scale_fill_brewer(palette="Set2") +
    theme(axis.title.x = element_blank(),axis.text.y=element_blank(),strip.text.x = element_text(size = 5)) +
    ggtitle("Total Emissions " %.% COUNTRY %.% " vs. Developed/Developing Countries by Sector, 1970-" %.% YEAR_U)


data_comb %>%
  #rbind(data_pred) %>%
  ggplot(aes(x=year, y=diff, color=forecast)) +
  facet_wrap(~sector_title,scales="free_y",ncol=1) +
  geom_line() +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")+
  ylab("Total Emissions (tCO2eq)") +
  theme_ghg()+
  scale_fill_brewer(palette="Set2") +
  theme(axis.title.x = element_blank(),axis.text.y=element_blank(),strip.text.x = element_text(size = 5)) +
  ggtitle("Total Emissions " %.% COUNTRY %.% " vs. Developed/Developing Countries by Sector, 1970-" %.% YEAR_U)
