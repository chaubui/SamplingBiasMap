clean_data <- function(seqmetadata, empresi, coords){
  
  # get just the frequency of sequences per location
  FreqSeqLocs<- as.data.frame(table(seqmetadata$newloc)) 
  names(FreqSeqLocs) <- c("location", "frequency")
  
  # get just the frequency of cases/outbreaks per location
  # first need to make location names consistent with sequence dataset
  stopwords <- c(" Sheng"," Shi", " Zizhiqu", " Huizu", " Uygur", " Zhuangzu" ) # remove unnecessay names
  FreqCaseLoc<- gsub(paste(stopwords, collapse="|"), "", empresi$admin1)
  FreqCaseLoc <- as.data.frame(table(FreqCaseLoc))
  names(FreqCaseLoc) <- c("location", "frequency")
  FreqCaseLoc$location <- gsub("Nei Mongol", "Mongolia", FreqCaseLoc$location) # fix mongolia naming
  FreqCaseLoc$location <- gsub("Xizang", "Tibet", FreqCaseLoc$location) # fix tibet naming
  
  # clean coordinate data
  names(coords) <- c("location", "Lat", "Long") # rename headers
  coords$location <- gsub("NingxiaHui", "Ningxia", coords$location) # rename ningxia
  
  # combine all to create one large dataframe
  
  FreqAll <- merge(FreqSeqLocs, FreqCaseLoc, all=T, by=c("location")) #create one dataframe
  names(FreqAll) <- c("location", "Sequences", "Outbreaks") # rename dataframe
  FreqAll <- merge(FreqAll, coords, all=T, by=c("location")) # add coordinate data 
  
  # clean large dataframe
  FreqAll <- FreqAll[!(FreqAll$location=="Taiwan" | FreqAll$location=="Tianjin"),]   #remove Taijin and Taiwan as don't need these locations
  FreqAll[is.na(FreqAll)] <- 0   #replace NAs with zeroes 
  FreqAll$ID <- seq.int(nrow(FreqAll))   #add ID column
  FreqAll <- melt(FreqAll, id.vars = c("location","Lat","Long","ID"), # melt data 
                  measure.vars = c("Sequences", "Outbreaks"))
  
  assign("freqdata", # assign the single large dataset to global environment
         FreqAll, 
         envir=globalenv())
  
  assign("coords", # assign the coordinate dataset to global environment
         coords, 
         envir=globalenv())
  
}