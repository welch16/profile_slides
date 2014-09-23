
rm(list = ls())
#library(profile)
library(profile)

load("../data/regions/problematic_peaks_140812.RData") # This contains the bam files to be used as character
                                       # vector and the regions of interest as GRangesList

widthPara <- 501            
maxBw <- 1
regionName <- "Consensus Peaks"
rChr <- ""
fl <- 200
mc <- 8
regions <- regions[[1]]    # Used to be GRangesList, changed it to GRanges
figsdir = "../tex/figs/generated"

test_all <- function(file, regionName, maxBw, fl, regions, rChr, mc = 8)
{
  prof = Profile(regionName = regionName,file = file,fileFormat = "bam",maxBandwidth = maxBw,fragLen = fl,remChr =rChr)
  regions(prof) = regions
  prof = loadReads(prof,floor(mc/2))
  prof = matchReads(prof,mc)
  prof = getCoverage(prof,mc)
  profmat = ProfileMatrix(prof,maxBw,mc)
  profmat = normalize.matrix(profmat)
  message("---")
  return(profmat)
}

files = files
profileMatrices = lapply(files,FUN = test_all,regionName,maxBw,fl,regions,rChr,mc)

profileMatrices = ProfileMatrixList(profileMatrices)

profileNames = sapply(files,function(x)gsub("/NO_BACKUP/KelesGroup/Tricia_Kiley/bam/Galaxy","",x)[[1]])
profileNames = sapply(profileNames,function(x)substring(x,first = 4))
profileNames = sapply(profileNames,function(x)gsub("Bowtie2_","",x))
profileNames = sapply(profileNames,function(x)gsub("_FILTERED_BED.bam","",x))
names(profileNames) = NULL
names(profileMatrices) = profileNames

starts = start(regions)
ends = end(regions)

pdf(file = file.path(figsdir,"Problematic_peaks.pdf"),width = 6,height = 4)
i=1
for(st in starts){
  p = plot.profiles(profileMatrices,condition = start == st)+
    scale_linetype_manual(values = c(1,1,1,2,2,2,3,3,4))+
      ggtitle(paste0("U00096.2:",starts[i],"-",ends[i]))
  print(p)
  i=i+1
}
dev.off()


