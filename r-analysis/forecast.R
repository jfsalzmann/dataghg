load("data-transf/data_base.RData")


## CHINA

data = data_base %>%
  filter(country %in% c("China","United States") | EU) %>%
  rename(GAS := GAS) %>%
  mutate(country = ifelse(EU,"EU",country)) %>%
  group_by(year,country,sector_title) %>%
  summarise(GAS_s=sum(GAS,na.rm=TRUE)) %>%
  na.omit() %>%
  filter(between(year,{{YEAR_L}},{{YEAR_U}})) %>%
  group_by(country,sector_title) %>%
  mutate(diff = GAS_s - lag(GAS_s, default = first(GAS_s), order_by = year), forecast = 0)


## Model 1: China's Peak

oos_end = data.frame(country = "China", year = FYEAR_L, sector_title = meta_sector_list, GAS_s = c(NA), diff = c(0), forecast=1)

oos = map_dfr(meta_sector_list,~data.frame(
    country = "China",
    year = (YEAR_U+1):(FYEAR_L[meta_sector_alc[.x]]-1),
    sector_title = .x,
    GAS_s = NA, diff = NA, forecast = 1
)) %>% rbind(oos_end)

data_ext = data %>% 
  filter(diff != 0 & country == "China" & year>={{YEAR_U}}-1) %>%
  rbind(oos) %>% 
  group_by(country,sector_title) %>%
  mutate(diff = na_interpolation(diff)) %>%
  filter(year>={{YEAR_U}}) %>%
  mutate(GAS_s = ifelse(is.na(GAS_s),max(GAS_s,na.rm = T) + accumulate(diff,sum),GAS_s)) %>%
  filter(year!={{YEAR_U}})


## Model 2: 2030 Intermediary Levels EU / China

factors = data %>%
  filter(year == YEAR_U, country %in% c("United States","EU")) %>%
  mutate(country = ifelse(country == "United States","US",country)) %>%
  group_by(country) %>%
  summarise(GAS_s_perc = GAS_s/sum(GAS_s)) %>%
  mutate(sector = row_number()) %>%
  spread(country, GAS_s_perc)

assumption = data.frame(
  US = c(3.251e9,NA,NA,NA,3.251e9),
  EU = c(2.085e9,NA,NA,NA,2.085e9),
  gas = meta_gas_list)

oos_comp = expand.grid(country = c("United States","EU"), sector_title = meta_sector_list, year=(YEAR_U+1):2030) %>%
  mutate(GAS_s = case_when(
    year != 2030 ~ 0,
    country=="United States" ~ assumption$US[meta_gas_alc[{{GAS}}]] * factors$US[meta_sector_alc[sector_title]],
    country=="EU" ~ assumption$EU[meta_gas_alc[{{GAS}}]] * factors$EU[meta_sector_alc[sector_title]]
  ), diff = NA, forecast=1) %>% mutate(GAS_s = ifelse(GAS_s == 0, NA, GAS_s))

data_ext_comp = data %>% 
  filter(country != "China") %>%
  rbind(oos_comp) %>% 
  group_by(country,sector_title) %>%
  mutate(GAS_s = na_interpolation(GAS_s))


## Model 3: S-Curve Decline to almost 0

oos_fade_comp = expand.grid(country = c("United States","EU"), sector_title = meta_sector_list, year=2031:(max(FYEAR_U))) %>%
  mutate(GAS_s = NA, diff = NA, forecast = 2)

oos_fade = map_dfr(meta_sector_list,~data.frame(
  year = (FYEAR_L[meta_sector_alc[.x]]+1):(max(FYEAR_U)),
  sector_title = .x,
  GAS_s = NA, diff = NA, forecast = 2, country="China"
)) %>% rbind(oos_fade_comp)




s_curve = function(year,base_year=2020,spread=10,start=1){
  case_when(
    year <= base_year+spread/3 ~ start*(1.04)*(1/2)*(1+(2/pi)*atan((pi/2)*-(year-base_year-spread/3)/2)),
    year > base_year+spread/3 ~ start*(1)*(1/2)*(1+(2/pi)*atan((pi/2)*-(year-base_year-spread/3)/2))
  )
}


data_fade = data_ext %>%
  rbind(data_ext_comp) %>%
  filter(country == "China" & year == FYEAR_L[meta_sector_alc[sector_title]] | year == 2030) %>%
  group_by(country,sector_title) %>%
  rbind(oos_fade) %>% 
  mutate(GAS_s = case_when(
      country == "China" ~ s_curve(
        year,
        FYEAR_L[meta_sector_alc[sector_title]],
        FYEAR_U[meta_sector_alc[sector_title]]-FYEAR_L[meta_sector_alc[sector_title]],
        first(GAS_s,order_by=year)
      ),
      TRUE ~ s_curve(
        year,
        2030,
        ifelse(country=="EU",FYEAR_EU,FYEAR_US)-2030,
        first(GAS_s,order_by=year)
      )
    )
  ) %>%
  filter(!(country == "China" & year == FYEAR_L[meta_sector_alc[sector_title]] | year == 2030))


## Prepare Graph Data & Merge


# data_double = data_ext %>%
#   filter(year == {{YEAR_U}}+1) %>% 
#   mutate(forecast = 0,diff=NA)
# 
# data_double2 = data_fade %>%
#   filter(year == 2031) %>% 
#   mutate(forecast = 1,diff=NA)

forecast = data %>%
  rbind(data_ext) %>%
  rbind(data_ext_comp) %>%
  rbind(data_fade) %>%
  group_by(country,sector_title) %>%
  mutate(
    diff = GAS_s - lag(GAS_s, default = first(GAS_s), order_by = year)
  ) %>%
  # rbind(data_double) %>%
  # rbind(data_double2) %>%
  mutate(forecast = as.factor(forecast))


PDATA$data_comb = forecast
save(forecast,file="data-transf/forecast_" %.% GAS %.%  "_" %.% max(FYEAR_L) %.% ".RData")


# data_comb %>%
#   #rbind(data_pred) %>%
#   ggplot(aes(x=year, y=diff2, color=forecast)) +
#   facet_wrap(~sector_title,scales="free_y",ncol=1) +
#   geom_line() +
#   scale_fill_brewer(palette = "Set2") +
#   theme(legend.position="none")+
#   ylab("Total Emissions (tCO2eq)") +
#   theme_ghg()+
#   scale_fill_brewer(palette="Set2") +
#   theme(axis.title.x = element_blank(),axis.text.y=element_blank(),strip.text.x = element_text(size = 5)) +
#   ggtitle("Total Emissions " %.% COUNTRY %.% " vs. Developed/Developing Countries by Sector, 1970-" %.% YEAR_U)


# 
# 
# b = 2030
# test = data.frame(x = seq(b-10,b+30,0.5))
# test %<>% mutate(y=s_curve(x,b,10,2))
# test %$% plot(x,y)


# oos2 = oos %>% mutate(diff2=diff)
#  data_ext2 = data %>% 
#   filter(year >= 2017) %>%
#   group_by(sector_title) %>%
#   mutate(diff = GAS_s - lag(GAS_s, default = first(GAS_s), order_by = year)) %>%
#   filter(diff != 0) %>%
#   mutate(diff2 = diff - lag(diff, default = first(diff), order_by = year)) %>%
#   summarise(diff2 = mean(diff2),diff=last(diff),GAS_s=last(GAS_s),year=last(year)) %>%
#   filter(diff2 != 0) %>%
#   rbind(oos2) %>% 
#   group_by(sector_title) %>%
#   mutate(diff2 = na_interpolation(diff2)) %>%
#   filter(year>=2019) %>%
#   mutate(diff = ifelse(is.na(diff),max(diff,na.rm = T) + accumulate(diff2,sum),diff),
#          GAS_s = ifelse(is.na(GAS_s),max(GAS_s,na.rm = T) + accumulate(diff,sum),GAS_s)) %>%
#   filter(year != 2019)




# data_pred = data %>%
#   nest() %>%
#   mutate(
#     model = map(data, ~lm(log(GAS_s)~year, data = .)),
#     param = map(model, broom::tidy),
#     oos = list(tibble(year = 2020:2060)),
#     pred = map2(model,oos,~broom::augment(.x,newdata=.y)),
#     pred = map(pred,~.x %>% rename(GAS_s := .fitted) %>% mutate(GAS_s = exp(GAS_s)))
#   ) %>% 
#   select(sector_title,pred) %>%
#   unnest(cols=c("pred"))

