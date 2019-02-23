## ----message = FALSE, warning = FALSE, comment = "R>"--------------------
library(GARPTools)

## ----comment = "R>"------------------------------------------------------
data("wtdeer_df")
head(wtdeer_df)

## ----comment = "R>"------------------------------------------------------
data("wtdeer_locations")
wtdeer_locations

## ----eval = TRUE, echo = FALSE-------------------------------------------
data(alt)
data(bio_1)
data(bio_12)


## ----eval = FALSE, echo = TRUE-------------------------------------------
#  files <- list.files(path=paste(system.file(package="GARPTools"),"/data", sep = ""),
#                      pattern = ".asc", full.names = TRUE)
#  
#  env_layers <- stack(files)
#  
#  writeRaster(env_layers[[1]], "C:/GARP/rasters/alt.asc", overwrite=TRUE)
#  writeRaster(env_layers[[2]], "C:/GARP/rasters/bio_1.asc", overwrite=TRUE)
#  writeRaster(env_layers[[3]], "C:/GARP/rasters/bio_12.asc", overwrite=TRUE)

