#########################
# Library

library(readxl)
library(dplyr)
library(xlsx)
library(reshape2)
library(doBy) # summaryBY : aggregate selon les variables demandes, avec la stat demande (min, max, sum, mean, length...)
library(effects)

####################################
# Setwd & opening - organizing files

#setwd("C:/Users/s03pb3/Dropbox/Project Data/Apus_melba/Meteo-data/data.txt/up to 2020")

BER <- read_excel("Meteoswiss-up-to-2022.09.xlsx", sheet ="BER", na = "-", col_types = c("text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
CRM <- read_excel("Meteoswiss-up-to-2022.09.xlsx", sheet ="CRM", na = "-", col_types = c("text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
GRE <- read_excel("Meteoswiss-up-to-2022.09.xlsx", sheet ="GRE", na = "-", col_types = c("text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
KOP <- read_excel("Meteoswiss-up-to-2022.09.xlsx", sheet ="KOP", na = "-", col_types = c("text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
WYN <- read_excel("Meteoswiss-up-to-2022.09.xlsx", sheet ="WYN", na = "-", col_types = c("text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

BER <- BER[, c("stn", "time", "tre200d0", "tre200dn", "tre200dx", "tre200j0", "tre200n0", "tre200nn", "tre200nx", "rka150d0", "rre150j0", "fkl010d0")]
CRM <- CRM[, c("stn", "time", "tre200d0", "tre200dn", "tre200dx", "tre200j0", "tre200n0", "tre200nn", "tre200nx", "rka150d0", "rre150j0", "fkl010d0")]
GRE <- GRE[, c("stn", "time", "tre200d0", "tre200dn", "tre200dx", "tre200j0", "tre200n0", "tre200nn", "tre200nx", "rka150d0", "rre150j0", "fkl010d0")]
KOP <- KOP[, c("stn", "time", "tre200d0", "tre200dn", "tre200dx", "tre200j0", "tre200n0", "tre200nn", "tre200nx", "rka150d0", "rre150j0", "fkl010d0")]
WYN <- WYN[, c("stn", "time", "tre200d0", "tre200dn", "tre200dx", "tre200j0", "tre200n0", "tre200nn", "tre200nx", "rka150d0", "rre150j0", "fkl010d0")]

d <- bind_rows(BER, CRM, GRE, KOP, WYN) # binding by rows and row names

# quality control that data are correctly merged
d[d$time == 19911024,]
BER[BER$time == 19911024,]
CRM[CRM$time == 19911024,]

d <- d[, c("stn", "time", "tre200d0", "tre200dn", "tre200dx", "tre200j0", "tre200n0", "tre200nn", "tre200nx", "rka150d0", "rre150j0", "fkl010d0")]

rm(BER); rm(CRM); rm(GRE); rm(KOP); rm(WYN) # removing dataset as of no more use

colnames(d)[colnames(d) == "stn"] <- "station"
colnames(d)[colnames(d) == "time"] <- "date"
colnames(d)[colnames(d) == "tre200nx"] <- "T.night.max"
colnames(d)[colnames(d) == "tre200nn"] <- "T.night.min"
colnames(d)[colnames(d) == "tre200n0"] <- "T.night.mean"
colnames(d)[colnames(d) == "tre200dx"] <- "T.daily.max"
colnames(d)[colnames(d) == "tre200dn"] <- "T.daily.min"
colnames(d)[colnames(d) == "tre200d0"] <- "T.daily.mean"
colnames(d)[colnames(d) == "tre200j0"] <- "T.day6_18.mean"
colnames(d)[colnames(d) == "rre150j0"] <- "Rain.day6_18"
colnames(d)[colnames(d) == "rka150d0"] <- "Rain.daily"
colnames(d)[colnames(d) == "fkl010d0"] <- "Wind.daily.mean"


# Exploration of the data shows that seems to be an error in the data (see lines 209)
# for the T.night.mean & T.day6_18.mean @ KOP => should be removing data those data

d$T.night.mean[d$station == "KOP"] <- NA
d$T.day6_18.mean[d$station == "KOP"] <- NA

###########################################################################
# Reshaping files to have a MEAN climate data PER DAY across stations

d1 <- summaryBy(T.daily.mean ~ date, d, FUN = function(x) mean(x, na.rm = TRUE))
colnames(d1)[colnames(d1) == "T.daily.mean.function(x) mean(x, na.rm = TRUE)"] <- "T.daily.mean"

d2 <- summaryBy(T.daily.min ~ date, d, FUN = function(x) mean(x, na.rm = TRUE))
colnames(d2)[colnames(d2) == "T.daily.min.function(x) mean(x, na.rm = TRUE)"] <- "T.daily.min"

d3 <- summaryBy(T.daily.max ~ date, d, FUN = function(x) mean(x, na.rm = TRUE))
colnames(d3)[colnames(d3) == "T.daily.max.function(x) mean(x, na.rm = TRUE)"] <- "T.daily.max"

d4 <- summaryBy(T.day6_18.mean ~ date, d, FUN = function(x) mean(x, na.rm = TRUE))
colnames(d4)[colnames(d4) == "T.day6_18.mean.function(x) mean(x, na.rm = TRUE)"] <- "T.day6_18.mean"

d5 <- summaryBy(T.night.mean ~ date, d, FUN = function(x) mean(x, na.rm = TRUE))
colnames(d5)[colnames(d5) == "T.night.mean.function(x) mean(x, na.rm = TRUE)"] <- "T.night.mean"

d6 <- summaryBy(T.night.min ~ date, d, FUN = function(x) mean(x, na.rm = TRUE))
colnames(d6)[colnames(d6) == "T.night.min.function(x) mean(x, na.rm = TRUE)"] <- "T.night.min"

d7 <- summaryBy(T.night.max ~ date, d, FUN = function(x) mean(x, na.rm = TRUE))
colnames(d7)[colnames(d7) == "T.night.max.function(x) mean(x, na.rm = TRUE)"] <- "T.night.max"

d8 <- summaryBy(Rain.daily ~ date, d, FUN = function(x) mean(x, na.rm = TRUE))
colnames(d8)[colnames(d8) == "Rain.daily.function(x) mean(x, na.rm = TRUE)"] <- "Rain.daily"

d9 <- summaryBy(Rain.day6_18 ~ date, d, FUN = function(x) mean(x, na.rm = TRUE))
colnames(d9)[colnames(d9) == "Rain.day6_18.function(x) mean(x, na.rm = TRUE)"] <- "Rain.day6_18"

d10 <- summaryBy(Wind.daily.mean ~ date, d, FUN = function(x) mean(x, na.rm = TRUE))
colnames(d10)[colnames(d10) == "Wind.daily.mean.function(x) mean(x, na.rm = TRUE)"] <- "Wind.daily.mean"

my_merge <- function(df1, df2){merge(df1, df2, by = "date")}    # Create own merging function to merge dataframes by "date"

d.summary <- Reduce(my_merge, list(d1, d2, d3, d4, d5, d6, d7, d8, d9, d10))

rm(d1); rm(d2); rm(d3); rm(d4); rm(d5); rm(d6); rm(d7); rm(d8); rm(d9); rm(d10)



d.summary$dateYMD <- paste(substr(d.summary$date, 1, 4),  substr(d.summary$date, 5, 6), substr(d.summary$date, 7, 8), sep = "-") # date in YMD
d.summary$dateYMD <- format(as.Date(d.summary$dateYMD, origin = "1900-01-01"), "%Y/%m/%d")

d.summary$year <- paste(substr(d.summary$date, 1, 4)) # extracting year & month
d.summary$month <- paste(substr(d.summary$date, 5, 6))

d.summary$year <- as.numeric(d.summary$year)
d.summary$month <- as.numeric(d.summary$month)

d.summary <- d.summary[, c(13, 14, 1, 12, 2:11)] # reordering the columns in the data frame

write.xlsx2(d.summary, "MeteoSwiss_summary_up-to-2022.09.xlsx", sheetName = "data", col.names = TRUE, row.names = FALSE)
write.csv(d.summary, "MeteoSwiss_summary_up-to-2022.09.csv", row.names = FALSE)


###########################################################################
# Exploring temporal trends in the climatic data

boxplot(T.daily.mean ~ year, data = subset(d.summary, month %in% c(6,7) & year > 1998))
boxplot(Rain.day6_18 ~ year, data = subset(d.summary, month %in% c(6,7) & year > 1998))

m <- lm(Rain.day6_18 ~ year, data = subset(d.summary, month %in% c(6,7) & year > 1998))
summary(m)
plot(allEffects(m))


###########################################################################
# Reshaping files long-to-wide to have climate data by station side by side

# http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format/#from-long-to-wide-1

d.T.daily.mean <- dcast(d, date ~ station, value.var = "T.daily.mean")

colnames(d.T.daily.mean)[colnames(d.T.daily.mean) == "BER"] <- "T.daily.mean.BER"
colnames(d.T.daily.mean)[colnames(d.T.daily.mean) == "CRM"] <- "T.daily.mean.CRM"
colnames(d.T.daily.mean)[colnames(d.T.daily.mean) == "GRE"] <- "T.daily.mean.GRE"
colnames(d.T.daily.mean)[colnames(d.T.daily.mean) == "KOP"] <- "T.daily.mean.KOP"
colnames(d.T.daily.mean)[colnames(d.T.daily.mean) == "WYN"] <- "T.daily.mean.WYN"


d.T.daily.min <- dcast(d, date ~ station, value.var = "T.daily.min")

colnames(d.T.daily.min)[colnames(d.T.daily.min) == "BER"] <- "T.daily.min.BER"
colnames(d.T.daily.min)[colnames(d.T.daily.min) == "CRM"] <- "T.daily.min.CRM"
colnames(d.T.daily.min)[colnames(d.T.daily.min) == "GRE"] <- "T.daily.min.GRE"
colnames(d.T.daily.min)[colnames(d.T.daily.min) == "KOP"] <- "T.daily.min.KOP"
colnames(d.T.daily.min)[colnames(d.T.daily.min) == "WYN"] <- "T.daily.min.WYN"


d.T.daily.max <- dcast(d, date ~ station, value.var = "T.daily.max")

colnames(d.T.daily.max)[colnames(d.T.daily.max) == "BER"] <- "T.daily.max.BER"
colnames(d.T.daily.max)[colnames(d.T.daily.max) == "CRM"] <- "T.daily.max.CRM"
colnames(d.T.daily.max)[colnames(d.T.daily.max) == "GRE"] <- "T.daily.max.GRE"
colnames(d.T.daily.max)[colnames(d.T.daily.max) == "KOP"] <- "T.daily.max.KOP"
colnames(d.T.daily.max)[colnames(d.T.daily.max) == "WYN"] <- "T.daily.max.WYN"


d.T.day6_18.mean <- dcast(d, date ~ station, value.var = "T.day6_18.mean")

colnames(d.T.day6_18.mean)[colnames(d.T.day6_18.mean) == "BER"] <- "T.day6_18.mean.BER"
colnames(d.T.day6_18.mean)[colnames(d.T.day6_18.mean) == "CRM"] <- "T.day6_18.mean.CRM"
colnames(d.T.day6_18.mean)[colnames(d.T.day6_18.mean) == "GRE"] <- "T.day6_18.mean.GRE"
colnames(d.T.day6_18.mean)[colnames(d.T.day6_18.mean) == "KOP"] <- "T.day6_18.mean.KOP"
colnames(d.T.day6_18.mean)[colnames(d.T.day6_18.mean) == "WYN"] <- "T.day6_18.mean.WYN"


d.T.night.mean <- dcast(d, date ~ station, value.var = "T.night.mean")

colnames(d.T.night.mean)[colnames(d.T.night.mean) == "BER"] <- "T.night.mean.BER"
colnames(d.T.night.mean)[colnames(d.T.night.mean) == "CRM"] <- "T.night.mean.CRM"
colnames(d.T.night.mean)[colnames(d.T.night.mean) == "GRE"] <- "T.night.mean.GRE"
colnames(d.T.night.mean)[colnames(d.T.night.mean) == "KOP"] <- "T.night.mean.KOP"
colnames(d.T.night.mean)[colnames(d.T.night.mean) == "WYN"] <- "T.night.mean.WYN"


d.T.night.min <- dcast(d, date ~ station, value.var = "T.night.min")

colnames(d.T.night.min)[colnames(d.T.night.min) == "BER"] <- "T.night.min.BER"
colnames(d.T.night.min)[colnames(d.T.night.min) == "CRM"] <- "T.night.min.CRM"
colnames(d.T.night.min)[colnames(d.T.night.min) == "GRE"] <- "T.night.min.GRE"
colnames(d.T.night.min)[colnames(d.T.night.min) == "KOP"] <- "T.night.min.KOP"
colnames(d.T.night.min)[colnames(d.T.night.min) == "WYN"] <- "T.night.min.WYN"


d.T.night.max <- dcast(d, date ~ station, value.var = "T.night.max")

colnames(d.T.night.max)[colnames(d.T.night.max) == "BER"] <- "T.night.max.BER"
colnames(d.T.night.max)[colnames(d.T.night.max) == "CRM"] <- "T.night.max.CRM"
colnames(d.T.night.max)[colnames(d.T.night.max) == "GRE"] <- "T.night.max.GRE"
colnames(d.T.night.max)[colnames(d.T.night.max) == "KOP"] <- "T.night.max.KOP"
colnames(d.T.night.max)[colnames(d.T.night.max) == "WYN"] <- "T.night.max.WYN"


d.Rain.daily <- dcast(d, date ~ station, value.var = "Rain.daily")

colnames(d.Rain.daily)[colnames(d.Rain.daily) == "BER"] <- "Rain.daily.BER"
colnames(d.Rain.daily)[colnames(d.Rain.daily) == "CRM"] <- "Rain.daily.CRM"
colnames(d.Rain.daily)[colnames(d.Rain.daily) == "GRE"] <- "Rain.daily.GRE"
colnames(d.Rain.daily)[colnames(d.Rain.daily) == "KOP"] <- "Rain.daily.KOP"
colnames(d.Rain.daily)[colnames(d.Rain.daily) == "WYN"] <- "Rain.daily.WYN"


d.Rain.day6_18 <- dcast(d, date ~ station, value.var = "Rain.day6_18")

colnames(d.Rain.day6_18)[colnames(d.Rain.day6_18) == "BER"] <- "Rain.day6_18.BER"
colnames(d.Rain.day6_18)[colnames(d.Rain.day6_18) == "CRM"] <- "Rain.day6_18.CRM"
colnames(d.Rain.day6_18)[colnames(d.Rain.day6_18) == "GRE"] <- "Rain.day6_18.GRE"
colnames(d.Rain.day6_18)[colnames(d.Rain.day6_18) == "KOP"] <- "Rain.day6_18.KOP"
colnames(d.Rain.day6_18)[colnames(d.Rain.day6_18) == "WYN"] <- "Rain.day6_18.WYN"


d.Wind.daily.mean <- dcast(d, date ~ station, value.var = "Wind.daily.mean")

colnames(d.Wind.daily.mean)[colnames(d.Wind.daily.mean) == "BER"] <- "Wind.daily.mean.BER"
colnames(d.Wind.daily.mean)[colnames(d.Wind.daily.mean) == "CRM"] <- "Wind.daily.mean.CRM"
colnames(d.Wind.daily.mean)[colnames(d.Wind.daily.mean) == "GRE"] <- "Wind.daily.mean.GRE"
colnames(d.Wind.daily.mean)[colnames(d.Wind.daily.mean) == "KOP"] <- "Wind.daily.mean.KOP"
colnames(d.Wind.daily.mean)[colnames(d.Wind.daily.mean) == "WYN"] <- "Wind.daily.mean.WYN"

my_merge <- function(df1, df2){merge(df1, df2, by = "date")}    # Create own merging function to merge dataframes by "date"
                              
dw <- Reduce(my_merge, list(d.T.daily.mean, d.T.daily.min, d.T.daily.max, d.T.day6_18.mean, d.T.night.mean, d.T.night.min, d.T.night.max, d.Rain.daily, d.Rain.day6_18, d.Wind.daily.mean))

# dw = data wide vs data long = d

# quality control that data are correctly merged
#d.wide[d.wide$date == 19911024, c("T.daily.mean.BER", "T.daily.min.BER", "T.day6_18.mean.BER", "Rain.day6_18.BER")]
#d[d$station =="BER" & d$date == 19911024, ]

rm(d.T.daily.mean); rm(d.T.daily.min); rm(d.T.daily.max); rm(d.T.day6_18.mean); rm(d.T.night.mean); rm(d.T.night.min); rm(d.T.night.max); rm(d.Rain.daily); rm(d.Rain.day6_18); rm(d.Wind.daily.mean)


####
# Exploring correlation across stations


cor(dw[, c(2:6)], use = "complete.obs") # T daily mean
cor(dw[, c(7:11)], use = "complete.obs") # T daily min
cor(dw[, c(12:16)], use = "complete.obs") # T daily max
cor(dw[, c(17:21)], use = "complete.obs") # T day 6_18
cor(dw[, c(22:26)], use = "complete.obs") # T night mean
cor(dw[, c(27:31)], use = "complete.obs") # T night min
cor(dw[, c(32:36)], use = "complete.obs") # T night max
cor(dw[, c(37:41)], use = "complete.obs") # Rain daily 
cor(dw[, c(42:46)], use = "complete.obs") # Rain day 6_18
cor(dw[, c(47:51)], use = "complete.obs") # Wind daily mean

# There seems to be an error in the data for the T.night.mean & T.day6_18.mean @ KOP => should be removing data those data


###
# Computing the mean values across stations (& number of stations with observations)


dw$T.daily.mean.SUM <- ifelse(is.na(dw$T.daily.mean.BER) == T, 0,  dw$T.daily.mean.BER) + 
                        ifelse(is.na(dw$T.daily.mean.CRM) == T, 0,  dw$T.daily.mean.CRM) +
                          ifelse(is.na(dw$T.daily.mean.GRE) == T, 0,  dw$T.daily.mean.GRE) +
                            ifelse(is.na(dw$T.daily.mean.KOP) == T, 0,  dw$T.daily.mean.KOP) + 
                              ifelse(is.na(dw$T.daily.mean.WYN) == T, 0,  dw$T.daily.mean.WYN)
  
  
dw$T.daily.mean.N <- ifelse(is.na(dw$T.daily.mean.BER) == T, 0, 1) + 
                       ifelse(is.na(dw$T.daily.mean.CRM) == T, 0, 1) +
                         ifelse(is.na(dw$T.daily.mean.GRE) == T, 0, 1) +
                          ifelse(is.na(dw$T.daily.mean.KOP) == T, 0, 1) + 
                            ifelse(is.na(dw$T.daily.mean.WYN) == T, 0, 1)

dw$T.daily.mean <- dw$T.daily.mean.SUM / dw$T.daily.mean.N




