# Script to generate a foliage height diversity raster from EcoDes-DK15 
# Jakob J. Assmann j.assmann@bio.au.dk 17 February 2022

# Dependencies
library(terra)
terraOptions(progress = 20)

# Load list of EcoDes-DK15 descriptors
maindir="O:/Nat_Ecoinformatics-tmp/au634851/EcoDes-DK15_v1.1.0/outputs/vegetation_proportion/"
dirnames=dir(path=maindir) 
raster_list=paste0(maindir,dirnames,'/',dirnames,'.vrt')

# Stratify vegetation according to Wilson (1974): 0–1.5 m, 1.5–9 m, and >9 m
prop_below_1.5 <- raster_list[1:3]
prop_below_9 <- raster_list[4:11]
prop_above_9 <- raster_list[12:24]

# Calculate cumulative proportions for layers
prop_below_1.5 <- sum(rast(prop_below_1.5))
prop_below_9 <- sum(rast(prop_below_9))
prop_above_9 <- sum(rast(prop_above_9))

# Adjust for rounding inaccuracies
prop_below_1.5[prop_below_1.5 > 10000] <- 10000
prop_below_9[prop_below_9 > 10000] <- 10000
prop_above_9[prop_above_9 > 10000] <- 10000

# Apply correction factor to convert to actual proportion
prop_below_1.5 <- prop_below_1.5 / 10000
prop_below_9 <- prop_below_9 / 10000
prop_above_9 <- prop_above_9 / 10000

# Calculate log proportion
prop_below_1.5_log <- log(prop_below_1.5)
prop_below_9_log <- log(prop_below_9)
prop_above_9_log <- log(prop_above_9)

# Set log proportion to 0 if proportion is 0
# This is done by convention as log 0 is not defined.
# (see https://stats.stackexchange.com/questions/57069/alternative-to-shannons-entropy-when-probability-equal-to-zero)
prop_below_1.5_log[prop_below_1.5 == 0] <- 0
prop_below_9_log[prop_below_9 == 0] <- 0
prop_above_9_log[prop_above_9 == 0] <- 0

# Calculate foliage height diversity -SUM(pi x log(pi))
foliage_height_div <- -1 * ((prop_below_1.5 * prop_below_1.5_log) +
                              (prop_below_9 * prop_below_9_log) +
                              (prop_above_9 * prop_above_9_log))

# Write out raster
writeRaster(foliage_height_div,
            "data/predictor_data/foliage_height_diversity/foliage_height_diversity.tif")