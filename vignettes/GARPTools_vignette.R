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


## ---- eval = TRUE, echo = FALSE------------------------------------------
library(SDMTools)

## ----comment = "R>", warning = FALSE, message = FALSE, results = "hide"----
rasterPrep(file.path = "C:/GARP/rasters", mask = nc_boundary, 
           output.path = "C:/GARP/resampled/")

## ----comment = "R>"------------------------------------------------------
data("wtdeer_locations")
alt_resample <- raster("C:/GARP/resampled/alt_resample.asc")

wtdeer_centroids <- centroid(x = alt_resample, points = wtdeer_locations, 
                             xy = wtdeer_df[,c("Latitude","Longitude")],
                             species = wtdeer_df$Species)

## ----comment = "R>", echo = -1, fig.width=4, fig.height=3, fig.align = "center", fig.cap = "Resampled altitude map of sampling area with sampling points (black) and centroid points (purple)."----
par(mar=c(2,2,2,1))
plot(alt_resample)
points(wtdeer_locations, pch = 16)
points(wtdeer_centroids, col = "purple")

## ---- eval=TRUE, echo=FALSE----------------------------------------------
library(rJava)
library(xlsx)

## ----comment = "R>"------------------------------------------------------
splitData(points = wtdeer_centroids, p = 0.75, type = "all", iterations = 10, 
          output = TRUE, output.path = "C:/GARP/wtdeer")

