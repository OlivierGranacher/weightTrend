# reads export.zip file from Download folder and saves activity data in data folder
# https://www.r-bloggers.com/apple-health-export-part-i/
library(XML)
library(tidyverse)
if (file.exists("~/Downloads/export.zip")) {
  rc <- unzip("~/Downloads/export.zip", exdir = "~/Downloads", overwrite = TRUE)
  if (length(rc) != 0) {
    health_xml <- xmlParse("~/Downloads/apple_health_export/export.xml")
    # takes about 70 seconds on my iMac
    health_df <- XML:::xmlAttrsToDataFrame(health_xml["//Record"], stringsAsFactors = FALSE) %>%
      as_tibble() %>% mutate(value = as.numeric(value))
    write_rds(health_df, "data/health.rds", compress = "gz")
    # removes export file
    if (file.exists("~/Downloads/export.zip")) file.remove("~/Downloads/export.zip")
    # removes directory of unziped file
    unlink("~/Downloads/apple_health_export", recursive = T)
  }
}
