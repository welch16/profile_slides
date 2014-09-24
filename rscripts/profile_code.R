
rm(list = ls())
library(profile)
source("all_functions.R")

## Load regions

dir = "../data"
dir1 = file.path(dir,"regions")
dir2 = file.path(dir,"bam")
peakfiles = file.path(dir1,list.files(dir1))
regions = lapply(peakfiles,narrowPeakToGRanges)

regionName = "CTCF-K562"
fileFormat = "bam"
maxBandwidth = 301
bandwidth = 151
fragLen = 200
remChr = "chrY"
windowExt = 2000
mc.cores = 7

files = list.files(dir2)
filenames = files[!grepl("bai",files)]
files = file.path(dir2,filenames)

# Set profile object
ourRegions = regions[[1]]
start(ourRegions) = regions[[1]]$summit - windowExt
end(ourRegions) = regions[[1]]$summit + windowExt

ourProfiles = lapply(files,function(x,ourRegions){
  ourProfile = Profile(regionName,x,fileFormat,maxBandwidth,fragLen,remChr)
  regions(ourProfile) = ourRegions
return(ourProfile)},ourRegions)

# Create profile matrices
ourProfiles = lapply(ourProfiles,function(x)
  loadReads(x,6))

ourProfiles = lapply(ourProfiles,function(x)
  matchReads(x,mc.cores))

ourProfiles = lapply(ourProfiles,function(x)
  getCoverage(x,mc.cores))

ourProfileMatrices = lapply(ourProfiles,function(x)
  ProfileMatrix(x,bandwidth,mc.cores))
names(ourProfileMatrices) = c("H3k27ac","H3k4me1","H3k4me3")

save(list = "ourProfileMatrices",file = "../data/generated/matrices.RData")

