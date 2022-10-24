load("data-transf/data_base.RData")

meta_countries = data_base %>% distinct(country,ISO)
meta_country_list_iso = meta_countries %$% setNames(ISO,country)
meta_country_list = meta_countries %$% setNames(country,country)
