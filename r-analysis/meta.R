load("data-transf/data_base.RData")

meta_countries = data_base %>% distinct(country,ISO)
meta_country_list_iso = meta_countries %$% setNames(ISO,country)
meta_country_list = meta_countries %$% setNames(country,country)

meta_gas_list = data_base %>%
  select(where(is_numeric)) %>%
  select(matches("^[A-Z]",ignore.case=F)) %>%
  select(-GDP_pc) %>%
  select(-contains("_")) %>%
  names() %>% setNames(.,.)

meta_gas_alc = setNames(1:5,meta_gas_list)

meta_gas_transf_list = data_base %>%
  select(where(is_numeric)) %>%
  select(matches("^[A-Z]",ignore.case=F)) %>%
  select(-GDP_pc) %>%
  select(contains("_")) %>%
  names() %>% setNames(.,.)

meta_sectors = data_base %>% distinct(sector_title) %>% arrange(sector_title)
meta_sector_list = meta_sectors %$% setNames(sector_title,sector_title)
meta_sector_alc = meta_sectors %$% setNames(1:5,sector_title)
