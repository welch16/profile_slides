


narrowPeakToGRanges <- function(file)
{
  peaks = read.table(file,stringsAsFactors=FALSE)  
  gr = GRanges(seqnames = peaks[,1],ranges = IRanges(start = peaks[,2], end = peaks[,3]),strand = "*")
  elementMetadata(gr)[["summit"]] = start(gr) + peaks[,10]
  return(gr)
}
