## Effort by country
plot_vms(vms_effort_steft, metric = "country", type = "effort", cap_year= 2022, cap_month= "October", line_count= 7)
# effort_dat$kw_fishing_hours <- effort_dat$kw_fishing_hours/1000
effort_dat <- vms_effort_steft %>% dplyr::mutate(country = dplyr::recode(country,
                                                                   FR = "France",
                                                                   ES = "Spain",
                                                                   PR = "Portugal",
                                                                   BE = "Belgium",
                                                                   IR = "Ireland",
                                                                   NL = "Netherlands",
                                                                   LT = "Lithuania",
                                                                   EE = "Estonia",
                                                                   DE = "Germany",
                                                                   GB = "United Kingdom",
                                                                   DK = "Denmark",
                                                                   NL = "Netherlands"))
effort_dat2 <- effort_dat %>% filter(year > 2013)
plot_vms(effort_dat2, metric = "country", type = "effort", cap_year= 2022, cap_month= "October", line_count= 7)
ggplot2::ggsave("2022_BrS_FO_Figure3_vms.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_vms(effort_dat, metric = "country", type = "effort", cap_year= 2022, cap_month= "October", line_count= 7, return_data = TRUE)
write.taf(dat, file= "2022_BrS_FO_Figure3_vms.csv", dir = "report")

## Landings by gear
plot_vms(vms_landings_data, metric = "gear_category", type = "landings", cap_year= 2022, cap_month= "October", line_count= 3)
vms_landings_data$totweight <- vms_landings_data$totweight/1000
landings_dat <- vms_landings_data %>% dplyr::mutate(gear_category = 
                                                       dplyr::recode(gear_category,
                                                                     Static = "Static gears",
                                                                     Midwater = "Pelagic trawls and seines",
                                                                     Otter = "Bottom otter trawls",
                                                                     `Demersal seine` = "Bottom seines",
                                                                     Dredge = "Dredges",
                                                                     Beam = "Beam trawls",
                                                                     'NA' = "Undefined"))


landings_dat2 <- landings_dat %>% filter(year > 2013)
plot_vms(landings_dat2, metric = "gear_category", type = "landings", cap_year= 2022, cap_month= "October", line_count= 3)
ggplot2::ggsave("2022_BrS_FO_Figure6_vms.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_vms(vms_landings_data, metric = "gear_category", type = "landings", cap_year= 2022, cap_month= "October", line_count= 3, return_data = TRUE)
write.taf(dat, file= "2022_BrS_FO_Figure6_vms.csv", dir = "report")

## Effort by gear
plot_vms(effort_dat2, metric = "gear_category", type = "effort", cap_year= 2022, cap_month= "October", line_count= 5)
effort_dat2 <- effort_dat2 %>% dplyr::mutate(gear_category = 
                                                   dplyr::recode(gear_category,
                                                                 Static = "Static gears",
                                                                 Midwater = "Pelagic trawls and seines",
                                                                 Otter = "Bottom otter trawls",
                                                                 `Demersal seine` = "Bottom seines",
                                                                 Dredge = "Dredges",
                                                                 Beam = "Beam trawls",
                                                                 'NA' = "Undefined"))

plot_vms(effort_dat2, metric = "gear_category", type = "effort", cap_year= 2022, cap_month= "October", line_count= 5)
ggplot2::ggsave("2022_BrS_FO_Figure8_vms.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <-plot_vms(effort_dat, metric = "gear_category", type = "effort", cap_year= 2022, cap_month= "October", line_count= 6, return_data = TRUE)
write.taf(dat, file= "2022_Brs_FO_Figure8_vms.csv", dir = "report")

