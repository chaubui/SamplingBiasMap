################################################################################
# this code takes metadata downloaded from GISAID.org and case data downloaded #
# from EMPRES-i.org and creates a map to show the differences in geographic    #
# distributions in China. Data is also cleaned.                                #  
################################################################################ 

# load libraries

library("reshape")
library("RQGIS")
library("rgdal")
library(ggplot2)
library(cowplot)

# run functions cleanData_func and SamplingBiasMap_func  

# load sequence metadata and empres-i data
my_seqmetadata <- read.csv("C:/Users/Chau/workspace/20180307_R_GIS/Data/SamplingBiasMapping/H5_seq_metadata.csv")
my_empresi <- read.csv("C:/Users/Chau/workspace/20180307_R_GIS/Data/SamplingBiasMapping/H5_empresi.csv")
my_coords <- read.table("C:/Users/Chau/workspace/20180307_R_GIS/Data/SamplingBiasMapping/coordinates.txt", header = FALSE)

# clean data using the clean_data function 

clean_data(my_seqmetadata, my_empresi, my_coords)

# load basemap (I downloaded mine from gadm.org) 

my_spdf <- readOGR("C:/Users/Chau/workspace/20180307_R_GIS/Data/CHN_adm_shp/CHN_adm1.shp", 
                   "CHN_adm1",
                   verbose = TRUE, 
                   stringsAsFactors = FALSE)

# use the data you generated earler to plot in a map

SamplingBiasMap(graph_title = "H5N1",
                spdf = my_spdf,
                data = freqdata,
                coordinateData = coords )
