SamplingBiasMap <- function(graph_title, spdf, data, coordinateData){
  #create basemap
  basemap <- ggplot(spdf, aes(x = long, y = lat)) +
    ggtitle(graph_title) +
    geom_polygon(data = spdf, fill="grey90", aes(group=group)) +
    geom_path(color="grey95",aes(group=group), size=0.1) +
    
    # graph style
    theme(axis.line=element_blank(),
          axis.text.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          legend.position = "none") 
  
  # add the freq data
  PlotData <- basemap + lapply(1:28, function(i)
    
    annotation_custom(grob = ggplotGrob(
      ggplot(freqdata[freqdata$ID == i,], aes(fill=variable)) +
        geom_bar(aes(x= location, y=value),
                 position='dodge',stat='identity') +
        labs(x = NULL, y = NULL) + 
        theme(legend.position = "none", rect = element_blank(),
              line = element_blank(), text = element_blank())
    ),
    xmin = (freqdata$Long[freqdata$ID == i] - 1.5)[1],
    xmax = (freqdata$Long[freqdata$ID == i] + 1.5)[1],
    ymin = (freqdata$Lat[freqdata$ID == i] - 0.5)[1],
    ymax = (freqdata$Lat[freqdata$ID == i] + 2)[1])
  ) +
    geom_text(data=coords, 
              aes(x = Long, y = Lat, label = location), 
              size=3) 
  
  # add legend
  legenddummy <- ggplot(freqdata[freqdata$ID == 1,], aes(fill=variable))+
    geom_bar(aes(x= location, y=value),
             position='dodge',stat='identity')
  legend <- get_legend(legenddummy)
  
  # Final plot with legend
  FinalPlot <- plot_grid(PlotData, legend, ncol = 2, rel_heights = c(1, 1),
                         rel_widths = c(1,.2))
  #create outputs
  
  assign(graph_title, 
         FinalPlot,
         envir=globalenv()) 
  
  print(FinalPlot)
  
}