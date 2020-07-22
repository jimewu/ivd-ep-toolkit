list.of.packages <- c("aod", "drc" ,"ggplot2", "ggExtra" ,
                      "VCA", "mcr", "chemCal", "knitr", "Rmisc")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)