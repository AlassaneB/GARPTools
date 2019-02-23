## ----message = FALSE, warning = FALSE, comment = "R>"--------------------
library(GARPTools)

## ----comment = "R>"------------------------------------------------------
data("wtdeer_df")
head(wtdeer_df)

## ----comment = "R>"------------------------------------------------------
data("wtdeer_locations")
wtdeer_locations

## ----eval = TRUE, echo = FALSE-------------------------------------------
library(raster)
data("env_layers")
writeRaster(env_layers[[1]], "C:/GARP/rasters/alt.asc", overwrite=TRUE)
writeRaster(env_layers[[2]], "C:/GARP/rasters/bio_1.asc", overwrite=TRUE)
writeRaster(env_layers[[3]], "C:/GARP/rasters/bio_12.asc", overwrite=TRUE)


## ----eval = FALSE, echo = TRUE-------------------------------------------
#  files <- list.files(path=paste(system.file(package="GARPTools"),"/data", sep = ""),
#                      pattern = ".asc", full.names = TRUE)
#  
#  env_layers <- stack(files)
#  
#  writeRaster(env_layers[[1]], "C:/GARP/rasters/alt.asc", overwrite=TRUE)
#  writeRaster(env_layers[[2]], "C:/GARP/rasters/bio_1.asc", overwrite=TRUE)
#  writeRaster(env_layers[[3]], "C:/GARP/rasters/bio_12.asc", overwrite=TRUE)

## ----comment = "R>", eval = FALSE, fig.height=2, fig.align = "center", fig.cap = "Three example environmental layers used in DesktopGARP experimental runs."----
#  plot(env_layers, nc = 3)

## ----comment = "R>", echo = -1, fig.width=4, fig.height=3, fig.align = "center", fig.cap = "Altitude of sampling area with sampling points."----
par(mar=c(3,2,2,1))
data("nc_boundary")
data("alt")


