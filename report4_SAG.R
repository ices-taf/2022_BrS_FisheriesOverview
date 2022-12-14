
library(icesTAF)
library(icesFO)
library(sf)
library(ggplot2)
library(dplyr)


##########
#Load data
##########

trends <- read.taf("model/trends.csv")
catch_current <- read.taf("model/catch_current.csv")
catch_trends <- read.taf("model/catch_trends.csv")

clean_status <- read.taf("data/clean_status.csv")

#set year and month for captions:
cap_month = "October"
cap_year = "2022"
ecoreg <- "BrS"
# set year for plot calculations

year = 2022


###########
## 3: SAG #
###########

#~~~~~~~~~~~~~~~#
# A. Trends by guild
#~~~~~~~~~~~~~~~#

unique(trends$FisheriesGuild)


# 1. Demersal
#~~~~~~~~~~~
# trends <- trends %>% filter(StockKeyLabel != "ghl.27.1-2")
# trends <- trends %>% filter(StockKeyLabel != "cod.27.1-2.coastN")
plot_stock_trends(trends, guild="demersal", cap_year, cap_month , return_data = FALSE)

#why? check with Sarah HERE
# trends2 <- trends %>% filter(StockKeyLabel != "cod.27.1-2.coastN")
# plot_stock_trends(trends2, guild="demersal", cap_year, cap_month , return_data = FALSE)
ggplot2::ggsave(paste0(cap_year, "_", ecoreg,"_FO_SAG_Trends_demersal.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="demersal", cap_year , cap_month, return_data = TRUE)
write.taf(dat, file =paste0(cap_year, "_", ecoreg, "_FO_SAG_Trends_demersal.csv"), dir = "report")

# 2. Pelagic
#~~~~~~~~~~~
# trends <- trends %>% filter(StockKeyLabel != "bsf.27.nea")
plot_stock_trends(trends, guild="pelagic", cap_year, cap_month , return_data = FALSE)
ggplot2::ggsave(paste0(year_cap, "_", ecoreg, "_FO_SAG_Trends_pelagic.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="pelagic", cap_year, cap_month, return_data = TRUE)
write.taf(dat,file =paste0(year_cap, "_", ecoreg, "_FO_SAG_Trends_pelagic.csv"), dir = "report")

# 3. Crustacean
#~~~~~~~~~~~
plot_stock_trends(trends, guild="crustacean", cap_year, cap_month ,return_data = FALSE )
trends2 <- trends %>% filter(StockKeyLabel != "MEAN")
plot_stock_trends(trends2, guild="crustacean", cap_year, cap_month ,return_data = FALSE )
ggplot2::ggsave(paste0(cap_year, "_", ecoreg, "_FO_SAG_Trends_crustacean.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="crustacean", cap_year , cap_month , return_data = TRUE)
write.taf(dat, file =paste0(cap_year, "_", ecoreg, "_FO_SAG_Trends_crustacean.csv"), dir = "report" )


#~~~~~~~~~~~~~~~~~~~~~~~~~#
# Ecosystem Overviews plot
#~~~~~~~~~~~~~~~~~~~~~~~~~#
guild <- read.taf("model/guild.csv")
trends <- read.taf("model/trends.csv")

# For this EO, they need separate plots with all info

guild2 <- guild %>% filter(Metric == "F_FMSY")
plot_guild_trends(guild, cap_year, cap_month,return_data = FALSE )
guild2 <- guild2 %>% filter(FisheriesGuild != "MEAN")
plot_guild_trends(guild2, cap_year , cap_month,return_data = FALSE )
ggplot2::ggsave(paste0(year_cap, "_", ecoreg, "_EO_SAG_GuildTrends_F.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
# ggplot2::ggsave("2019_BtS_EO_GuildTrends_noMEAN_F.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

guild2 <- guild %>% filter(Metric == "SSB_MSYBtrigger")
guild3 <- guild2 %>% dplyr::filter(FisheriesGuild != "MEAN")
plot_guild_trends(guild3, cap_year, cap_month,return_data = FALSE )
ggplot2::ggsave(paste0(year_cap, "_", ecoreg, "_EO_SAG_GuildTrends_SSB.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)


dat <- plot_guild_trends(guild, cap_year, cap_month ,return_data = TRUE)
write.taf(dat, file =paste0(year_cap, "_", ecoreg, "_EO_SAG_GuildTrends.csv"), dir = "report" )

trends2 <- trends %>% filter(Metric == "F_FMSY"|Metric =="SSB_MSYBtrigger")
dat <- trends2[,1:2]
dat <- unique(dat)
dat <- dat %>% filter(StockKeyLabel != "MEAN")
dat2 <- sid %>% select(c(StockKeyLabel, StockKeyDescription))
dat <- left_join(dat,dat2)
write.taf(dat, file =paste0(year_cap, "_", ecoreg, "_EO_SAG_SpeciesGuildList.csv"), dir = "report", quote = TRUE )

#~~~~~~~~~~~~~~~#
# B.Current catches
#~~~~~~~~~~~~~~~#

#Stocks assessed outside ICES
catch_current2 <- catch_current %>% filter(StockKeyLabel != "cod.27.1-2")
catch_current2 <- catch_current2 %>% filter(StockKeyLabel != "had.27.1-2")
catch_current2 <- catch_current2 %>% filter(StockKeyLabel != "cap.27.1-2")
catch_current2 <- catch_current2 %>% filter(StockKeyLabel != "ghl.27.1-2")
catch_current2 <- catch_current2 %>% filter(StockKeyLabel != "reb.27.1-2")

# catch_current$Status[which(catch_current$StockKeyLabel == "cod.27.1-2")] <- "GREY" 
# catch_current$Status[which(catch_current$StockKeyLabel == "had.27.1-2")] <- "GREY"  
# catch_current$Status[which(catch_current$StockKeyLabel == "cap.27.1-2")] <- "GREY"  
# catch_current$Status[which(catch_current$StockKeyLabel == "ghl.27.1-2")] <- "GREY"  
# catch_current$Status[which(catch_current$StockKeyLabel == "reb.27.1-2")] <- "GREY"  

# 1. Demersal
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current2, guild = "demersal", caption = TRUE, cap_year, cap_month, return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current2, guild = "demersal", caption = TRUE, cap_year , cap_month , return_data = TRUE)
write.taf(bar_dat, file =paste0(cap_year, "_", ecoreg, "_FO_SAG_Current_demersal.csv"), dir = "report" )

kobe <- plot_kobe(catch_current2, guild = "demersal", caption = TRUE, cap_year , cap_month , return_data = FALSE)
#kobe_dat is just like bar_dat with one less variable
#kobe_dat <- plot_kobe(catch_current, guild = "Demersal", caption = T, cap_year , cap_month , return_data = TRUE)

#Check this file name
png("report/2022_BrS_FO_SAG_Current_demersal.png",
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "demersal")
dev.off()

# 2. Pelagic
#~~~~~~~~~~~
#Check 2022
# catch_current$Status[which(catch_current$StockKeyLabel == "cap.27.1-2")] <- "RED"

bar <- plot_CLD_bar(catch_current2, guild = "pelagic", caption = TRUE, cap_year, cap_month , return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current2, guild = "pelagic", caption = TRUE, cap_year , cap_month , return_data = TRUE)
write.taf(bar_dat, file =paste0(year_cap, "_", ecoreg, "_FO_SAG_Current_pelagic.csv"), dir = "report")

catch_current2 <- unique(catch_current2)
kobe <- plot_kobe(catch_current2, guild = "pelagic", caption = TRUE, cap_year , cap_month , return_data = FALSE)
#check this file name
png("report/2022_BrS_FO_SAG_Current_pelagic.png",
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "pelagic")
dev.off()

# 3. Crustacean
#~~~~~~~~~~~
# catch_current$Status[which(catch_current$StockKeyLabel == "sol.27.20-24")] <- "GREEN"

bar <- plot_CLD_bar(catch_current2, guild = "crustacean", caption = TRUE, cap_year , cap_month , return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current2, guild = "crustacean", caption = TRUE, cap_year , cap_month , return_data = TRUE)
write.taf(bar_dat, file =paste0(year_cap, "_", ecoreg, "_FO_SAG_Current_crustacean.csv"), dir = "report" )

kobe <- plot_kobe(catch_current2, guild = "crustacean", caption = TRUE, cap_year , cap_month , return_data = FALSE)
#check this file name
png("report/2022_BrS_FO_SAG_Current_crustacean.png",
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "crustacean")
dev.off()


# 4. All
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current2, guild = "All", caption = TRUE, cap_year , cap_month , return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current2, guild = "All", caption = TRUE, cap_year, cap_month , return_data = TRUE)
write.taf(bar_dat, file =paste0(cap_year, "_", ecoreg, "_FO_SAG_Current_All.csv"), dir = "report" )

top_10 <- bar_dat %>% top_n(10, total)
bar <- plot_CLD_bar(top_10, guild = "All", caption = TRUE, cap_year , cap_month , return_data = FALSE)


# catch_current2 <- catch_current %>% filter(StockKeyLabel != ("cod.27.1-2"))
# catch_current2 <- catch_current2 %>% filter(StockKeyLabel != ("had.27.1-2"))

kobe <- plot_kobe(top_10, guild = "All", caption = TRUE, cap_year, cap_month , return_data = FALSE)
#check this file name
png("report/2022_BrS_FO_SAG_Current_All.png",
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "All stocks top 10")
dev.off()



#~~~~~~~~~~~~~~~#
#C. ICES pies
#~~~~~~~~~~~~~~~#

plot_status_prop_pies(clean_status, cap_month, cap_year)
# will make qual_green just green
unique(clean_status$FishingPressure)
# clean_status2 <- clean_status
clean_status$FishingPressure <- gsub("qual_GREEN", "GREEN", clean_status$FishingPressure)
# plot_status_prop_pies(clean_status2, cap_month, cap_year)
plot_status_prop_pies(clean_status, cap_month, cap_year)
ggplot2::ggsave(paste0(year_cap,"_", ecoreg, "_FO_SAG_ICESpies.png"), path= "report/", width = 178, height = 178, units = "mm", dpi = 300)

dat <- plot_status_prop_pies(clean_status, cap_month, cap_year, return_data = TRUE)
write.taf(dat, file= paste0(year_cap,"_", ecoreg, "_FO_SAG_ICESpies.csv"),dir ="report")

#second run without 5 stocks

plot_status_prop_pies(clean_status_updated, cap_month, cap_year)
# will make qual_green just green
unique(clean_status_updated$FishingPressure)
# clean_status2 <- clean_status
# clean_status$FishingPressure <- gsub("qual_GREEN", "GREEN", clean_status$FishingPressure)
# plot_status_prop_pies(clean_status2, cap_month, cap_year)
# plot_status_prop_pies(clean_status, cap_month, cap_year)
ggplot2::ggsave(paste0(year_cap,"_", ecoreg, "_FO_SAG_ICESpies_without5stocks.png"), path= "report/", width = 178, height = 178, units = "mm", dpi = 300)

dat <- plot_status_prop_pies(clean_status_updated, cap_month, cap_year, return_data = TRUE)
write.taf(dat, file= paste0(year_cap,"_", ecoreg, "_FO_SAG_ICESpies_without5stocks.csv"),dir ="report")


#~~~~~~~~~~~~~~~#
#D. GES pies
#~~~~~~~~~~~~~~~#

#check, some issue with red
plot_GES_pies(clean_status_updated, catch_current, cap_month, cap_year)
unique(clean_status_updated$FishingPressure)
unique(clean_status_updated$StockSize)

# clean_status2 <- clean_status
# clean_status2$FishingPressure<- gsub("qual_GREEN", "GREEN", clean_status2$FishingPressure) 
# unique(clean_status2$FishingPressure)
# plot_GES_pies(clean_status2, catch_current, cap_month, cap_year)

ggplot2::ggsave(paste0(year_cap,"_",ecoreg,"_FO_SAG_GESpies_without5stocks.png"),path = "report",width = 178, height = 178, units = "mm",dpi = 300)

dat <- plot_GES_pies(clean_status_updated, catch_current, cap_month, cap_year, return_data = TRUE)
write.taf(dat, file = paste0(year_cap,"_",ecoreg, "_FO_SAG_GESpies_without5stocks.csv"),dir ="report")

#~~~~~~~~~~~~~~~#
#E. ANNEX TABLE
#~~~~~~~~~~~~~~~#
#pending

dat <- format_annex_table(clean_status, year)


# dat <- read.csv("report/2021_BrS_FO_SAG_annex_table.csv", header = TRUE)
# format_annex_table_html(dat,"BrS",2022)
write.taf(dat, file = paste0(year_cap,"_", ecoreg, "_FO_SAG_annex_table.csv"), dir = "report", quote = TRUE)

# This annex table has to be edited by hand,
# For SBL and GES only one values is reported,
# the one in PA for SBL and the one in MSY for GES
