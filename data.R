# Initial formatting of the data

library(icesTAF)
taf.library(icesFO)
library(dplyr)

mkdir("data")

# load species list
species_list <- read.taf("bootstrap/data/FAO_ASFIS_species/species_list.csv")
sid <- read.taf("bootstrap/data/ICES_StockInformation/sid.csv")
# effort$sub.region <- tolower(effort$sub.region)
# unique(effort$sub.region)


# 1: ICES official catch statistics

hist <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_historical_catches.csv")
official <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_2006_2018_catches.csv")
prelim <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_preliminary_catches.csv")

catch_dat <-
  format_catches(2022, "Barents Sea",
    hist, official, prelim, species_list, sid)

#preliminary catches are not complete
catch_dat <-
        format_catches(2022, "Barents Sea",
                       hist, official,NULL, species_list, sid)


out <-unique(grep("erring", catch_dat$COMMON_NAME, value = TRUE))
#[1] "Pacific herring"  "Atlantic herring"
out2<-unique(grep("ackerel", catch_dat$COMMON_NAME, value = TRUE))
out3<-unique(grep("lue whiting", catch_dat$COMMON_NAME, value = TRUE))
out <- append(out, out2)
out <- append(out, out3)

library(operators)
catch_dat <- dplyr::filter(catch_dat, COMMON_NAME %!in% out)
detach("package:operators", unload=TRUE)


write.taf(catch_dat, dir = "data", quote = TRUE)


# 2: SAG
sag_sum <- read.taf("bootstrap/data/SAG_data/SAG_summary.csv")
sag_refpts <- read.taf("bootstrap/data/SAG_data/SAG_refpts.csv")
sag_status <- read.taf("bootstrap/data/SAG_data/SAG_status.csv")


# 2022 update: this still applies:
sag_complete$FMSY[which(sag_complete$FishStock == "pok.27.1-2")] <- 0.32
sag_complete$MSYBtrigger[which(sag_complete$FishStock == "pok.27.1-2")] <- 220000

sag_complete$FMSY[which(sag_complete$FishStock == "cod.27.1-2.coastN")] <- 0.176
sag_complete$MSYBtrigger[which(sag_complete$FishStock == "cod.27.1-2.coastN")] <- 67743

# sag_complete$FMSY[which(sag_complete$FishStock == "cod.27.1-2.coastN")] <- 0.32
# sag_complete$MSYBtrigger[which(sag_complete$FishStock == "cod.27.1-2.coastN")] <- 220000


clean_sag <- format_sag(sag_complete, sid)
clean_status <- format_sag_status(status, 2022, "Barents Sea")

# we can't show sag data for cod, had, cap, ghl and reb:


Barents_stockList <- c("aru.27.123a4",
                       # "cap.27.1-2",
                       # "cod.27.1-2",
                       "cod.27.1-2.coastN",
                       "gfb.27.nea",
                       # "ghl.27.1-2",
                       # "had.27.1-2",
                       "lin.27.1-2",
                       "pok.27.1-2",
                       "pra.27.1-2",
                       # "reb.27.1-2",
                       "reg.27.1-2",
                       "rjr.27.23a4",
                       "rng.27.1245a8914ab",
                       "tsu.27.nea",
                       "usk.27.1-2")

clean_sag<-clean_sag%>%filter(StockKeyLabel %in% Barents_stockList)
clean_status<-clean_status%>%filter(StockKeyLabel %in% Barents_stockList)

write.taf(clean_sag, dir = "data")
write.taf(clean_status, dir = "data", quote = TRUE)
