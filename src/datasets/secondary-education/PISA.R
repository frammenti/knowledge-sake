library(dplyr)
library(EdSurvey)
library(sas7bdat)
library(countrycode)

date_seq = c("2000", "2003", "2006", "2009", "2012", "2015", "2018", "2022")

data_list <- list()

for (i in seq_along(date_seq)) {
  date <- date_seq[i]
  pisa_full <- readPISA(
    path=sprintf("PISA/%s", date),
    database="INT",
    cognitive="score",
    forceReread = FALSE,
    countries=c(
      "aut", "bel", "bgr", "hrv", "cyp", "cze", "dnk", "est",
      "fin", "fra", "deu", "grc", "hun", "irl", "ita", "lva",
      "ltu", "lux", "mlt", "nld", "pol", "prt", "rou", "svk",
      "svn", "esp", "swe", "gbr"))
  
  # Save codebook for each year for inspection of the available parameters
  codebook <- showCodebook(pisa_full, labelLevels = FALSE)
  if (date >= "2018") {
    codebook <- as.data.frame(codebook[[1]])
    codebook$Labels <- lapply(codebook$Labels, function(x) if (is.null(x)) NA else x) |>
      unlist()
  }
  write.csv(codebook, sprintf("PISA/Codebooks/%s.csv", date), row.names = TRUE)
  
  base_cols <- c("cnt", "read", "math")
  
  if (date == "2000") {
    # Align ESCS data with survey data
    align_cols <- c("schoolid", "stidstd")
    pisa_list <- getData(pisa_full, c(base_cols, align_cols))
    pisa_data <- bind_rows(pisa_list)
    
    escs_data <- read.sas7bdat("PISA/2000/ESCS_PISA2000.sas7bdat")
    names(escs_data) <- tolower(names(escs_data))
    escs_data$cnt <- countrycode(escs_data$cnt, origin = "iso3c", destination = "country.name") |>
                     toupper() |>
                     as.factor()
    escs_data[align_cols] <- lapply(escs_data[align_cols], as.numeric)
    pisa_data <- merge(pisa_data, escs_data, by = c("cnt", align_cols), all.x = TRUE)
    pisa_data <- pisa_data[, !(names(pisa_data) %in% c(align_cols, "subnatio"))]
  } else {
    # Select math scores, reading scores and ESCS index
    pisa_list <- getData(pisa_full, c(base_cols, "escs"))
    
    # Bind countries in a single data frame
    pisa_data <- bind_rows(pisa_list)
  }
  
  rm(pisa_full, pisa_list, codebook)
  gc()
  
  # Average over plausible scores for math and reading test
  read_cols <- grep("pv\\d+read", names(pisa_data), value = TRUE)
  math_cols <- grep("pv\\d+math", names(pisa_data), value = TRUE)
  pisa_data$read <- rowMeans(pisa_data[, read_cols])
  pisa_data$math <- rowMeans(pisa_data[, math_cols])
  pisa_data <- pisa_data[, !names(pisa_data) %in% c(read_cols, math_cols)]
  
  # Add year column
  pisa_data$year <- date
  
  data_list[[i]] <- pisa_data
}
# Bind years in a single data frame
data <- bind_rows(data_list)

rm(data_list, pisa_data, escs_data)
gc()

# Enforce case consistency for country names
iso_mapped <- countrycode(data$cnt, origin = "iso3c", destination = "country.name")
title_mapped <- tools::toTitleCase(tolower(data$cnt))
countries <- ifelse(!is.na(iso_mapped), iso_mapped, title_mapped)
countries <- gsub("Czech Republic", "Czechia", countries)
countries <- gsub("Slovak Republic", "Slovakia", countries)
data$cnt <- countries

rm(iso_mapped, title_mapped, countries)
gc()

# Remove rows without ESCS Index and adjust precision
data <- data[!is.na(data$escs),]

# Rename columns
names(data)[names(data) == 'cnt'] <- 'Country'
names(data)[names(data) == 'math'] <- 'Math Score'
names(data)[names(data) == 'read'] <- 'Reading Score'
names(data)[names(data) == 'escs'] <- 'ESCS Index'
names(data)[names(data) == 'year'] <- 'Year'

data_1 <- subset(data, Year <= 2009)
data_2 <- subset(data, Year >= 2012)

write.csv(data_1, "scores_vs_escs_00_09.csv", row.names = TRUE)
write.csv(data_2, "scores_vs_escs_12_22.csv", row.names = TRUE)
