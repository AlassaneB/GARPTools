#' Calculates the z-score associated with the AUC
#'
#' \code{zAUC} Returns the z-score associated with the AUC of the best model subset output by DesktopGARP.
#'
#' @param n a numeric value specifying the number of models in the best subset outputted by DesktopGARP
#' @param x a raster object of the summated raster of the best models output by DesktopGARP
#' @param points a spatial object of presence data to use for testing locations
#'
#' @return Returns the z-score of the AUC.
#'
#' @details For discrete cutpoints (\code{n}), represents the number of models that agree on a predicted presence location.
#'
#' The raster object (\code{x}) should be a raster representing the number of models that agree on a predicted presence location per pixel and that outtput by \code{\link{sumRasters}}.
#'
#' The shapefile \code{points} should presence locations that were not used by DesktopGARP for model training and those output by \code{\link{splitData}}.
#'
#' @seealso \code{\link{aucGARP}}
#'
#' @examples
#'   set.seed(0)
#'   r   <- raster(ncols = 100, nrows = 100)
#'   r[] <- rbinom(5, 10, 0.3)
#'   hs  <- data.frame("Latitude" = c(-89, 72, 63, 42, 54), "Longitude" = c(-12, 13, 24, 26, 87), "Species" = rep("Homo_sapiens", 5))
#'   zAUC(n = 10, x = r, points = SpatialPoints(hs[,1:2]))
#'
#' @import raster
#' @import sp
#'
#' @export


zAUC <- function(n, x, points){

  #Extract values from summated grid at test point locations
  grid = x
  taxa.models <- extract(grid, points)
  if(any(is.na(taxa.models))){stop("One or more testing points do not overlap raster.")}

  #Create cutpoints dataframe
  cutpoints <- data.frame(seq(0, n, 1))
  names(cutpoints) <- "cutpoint"

  #Summarize each cutpoint
  for(i in 1:dim(cutpoints)[1]){
    cutpoints$taxa.present[i]   <- sum(taxa.models == i-1)
    cutpoints$cutpoint.area[i]  <- freq(grid, value = i-1)
    cutpoints$no.taxa.pixels[i] <- freq(grid, value = i-1) - sum(taxa.models == i-1)
    cutpoints$cum.area[i] <- ifelse(cutpoints$cutpoint[i] == 0, 0,
                                    ifelse(cutpoints$cutpoint[i] == 1,
                                           (cutpoints$no.taxa.pixels[1] + cutpoints$no.taxa.pixels[i]),
                                           (cutpoints$no.taxa.pixels[i] + cutpoints$cum.area[i-1])))
  }

  #Calculate confusion matrix
  for(i in 1:dim(cutpoints)[1]){
    cutpoints$a[i] <- ifelse(cutpoints[i,1] == 0, (length(taxa.models) - cutpoints$taxa.present[i]), (cutpoints$a[i-1] - cutpoints$taxa.present[i]))
    cutpoints$b[i] <- ifelse(cutpoints[i,1] == 0, cutpoints$no.taxa.pixels[i], (cutpoints$b[i-1] + cutpoints$no.taxa.pixels[i]))
    cutpoints$c[i] <- ifelse(cutpoints[i,1] == 0, cutpoints$taxa.present[i], (cutpoints$c[i-1] + cutpoints$taxa.present[i]))
    cutpoints$d[i] <- ifelse(cutpoints[i,1] == 0, (sum(cutpoints$no.taxa.pixels) - cutpoints$no.taxa.pixels[i]), (cutpoints$d[i-1] - cutpoints$no.taxa.pixels[i]))
  }

  #Calculate z-score
  mu.exp <- (sum(cutpoints$taxa.present) + sum(cutpoints$no.taxa.pixels))/2
  for(i in 1:dim(cutpoints)[1]){
    cutpoints$mid.rank[i] <- ifelse(cutpoints[i,1] == 0, (0.5 * (cutpoints$cutpoint.area[i] + 1)), (cutpoints$mid.rank[i-1] + (0.5 * (cutpoints$cutpoint.area[i] + 1))))
    cutpoints$mu[i] <- cutpoints$taxa.present[i] * cutpoints$mid.rank[i]
    cutpoints$d3[i] <- ((cutpoints$taxa.present[i] + cutpoints$no.taxa.pixels[i])^3) - (cutpoints$taxa.present[i] + cutpoints$no.taxa.pixels[i])
  }
  mu.obs <- sum(cutpoints$mu)
  var <- ((sum(cutpoints$taxa.present) * sum(cutpoints$no.taxa.pixels) * (sum(cutpoints$taxa.present) + sum(cutpoints$no.taxa.pixels) + 1))/12) -
    ((sum(cutpoints$taxa.present) * sum(cutpoints$no.taxa.pixels) * sum(cutpoints$d3))/(12 * (sum(cutpoints$taxa.present) +
                                                                                                sum(cutpoints$no.taxa.pixels)) * ((sum(cutpoints$taxa.present) + sum(cutpoints$no.taxa.pixels)) - 1)))
  stdev <- sqrt(var)
  z <- (mu.obs-mu.exp)/stdev
  return(z)
}
