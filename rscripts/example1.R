
# Load data
rm(list = ls())
library(profile)
source("all_functions.R")
load("../data/generated/matrices.RData")

# Normalize matrices
ourProfileMatrices = lapply(ourProfileMatrices,FUN = normalize.matrix)

# Convert them to list
ourProfileMatrixList = ProfileMatrixList(ourProfileMatrices)

dir = "../data"
dir1 = file.path(dir,"regions")
peakfiles = file.path(dir1,list.files(dir1))
regions = lapply(peakfiles,narrowPeakToGRanges)
windowExt = 2000
figsdir = "../tex/figs/generated"

# Add one vector to regions for subseting:

ourProfileMatrix = ourProfileMatrices[[1]]
dnaseOverlap =  countOverlaps(regions(ourProfileMatrix),regions[[2]])
pol2bOverlap = countOverlaps(regions(ourProfileMatrix),regions[[3]])

## CODE OF SLIDES

## # Different ways to add a vector to regions:
## # 1
## ourProfileMatrix = addColumn(ourProfileMatrix,"dnase",dnaseOverlap)
## # 2
## elementMetadata(regions(ourProfileMatrix))[["pol2b"]]= pol2bOverlap
## # 3
## regions(ourProfileMatrix)$dnase = dnaseOverlap


## # Subseting
## subset.pm(ourProfileMatrix,dnaseOverlap > 0)
## subset.pm(ourProfileMatrix,dnaseOverlap == 1)
## subset.pm(ourProfileMatrix,seqnames == "chr1")

## # Averaging
## meanProfile(ourProfileMatrix)
## meanProfile(ourProfileMatrix,trim = .5)
## meanProfile(ourProfileMatrix,trim = .1)

# Add dnaseOverlap to all profile matrices
ourProfileMatrices = lapply(ourProfileMatrices,function(x,name,vec)addColumn(x,name,vec),
  "dnase",dnaseOverlap)
ourProfileMatrices = lapply(ourProfileMatrices,function(x,name,vec)addColumn(x,name,vec),
  "pol2b",pol2bOverlap)

# Generating some plots:
ourProfileMatrices = ProfileMatrixList(ourProfileMatrices)
names(ourProfileMatrices) = c("H3k27ac","H3k4me1","H3k4me3")

pdf(file = file.path(figsdir,"basis.pdf"),width = 6,height =4)
p1 =plot.profiles(ourProfileMatrices)
print(p1)
dev.off()

# Tweaking the plot
pdf(file = file.path(figsdir,"basisText.pdf"),width = 6,height=4)
p2 = p1 + theme(legend.position = "bottom")+ggtitle("K562 histone profile")
print(p2)
dev.off()

# not dashed line
pdf(file = file.path(figsdir,"basisfull.pdf"),width=6,height =4)
p3 = p2 + scale_linetype_manual(values=rep(1,3))+
  scale_colour_manual(values = c("coral1","royalblue","mediumseagreen"))
print(p3)
dev.off()                      

# median profiles
pdf(file =file.path(figsdir,"medianprofile.pdf"))
q1 = plot.profiles(ourProfileMatrices,trim=0.5,
  coord = seq(-windowExt,windowExt),condition= dnase > 0 )+
  theme(legend.position = "bottom")+
  ggtitle("K562 histone profile")+
  xlab("distance from summit")+
  ylab("normalized counts")
print(q1)
dev.off()

# more effects
pdf(file = file.path(figsdir,"medianprofileExtra.pdf"))
q2 = q1 + scale_linetype_manual(values = rep(1,3))+
  geom_vline(xintercept = 0,linetype ="longdash")
print(q2)
dev.off()
