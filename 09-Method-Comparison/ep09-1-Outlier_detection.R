#Part 0. Preparations: configuration area
#Load package needed
Packages <- c("dplyr", "ggplot2", "EnvStats", "knitr")
lapply(Packages, library, character.only = TRUE)

#Set working directory using rstudioapi
DIR <- dirname(rstudioapi::getSourceEditorContext()$path)
TIME <- format(Sys.time(), "%Y-%m%d-%H%M%S")
RPRT.DIR <- paste("Report", TIME, sep = "_")
setwd(DIR)

#Read setting for analysis
SET <- read.csv("setting.csv")

#Configuration for figures to be exported
FIG_W_CM <- SET$FIG_W_CM #Figure width in cm
FIG_H_CM <- SET$FIG_H_CM #Figure height in cm
FIG_DPI <- SET$FIG_DPI #Figure resolution

#Read data and assign as DAT data.frame
FILE <- "data.csv" #file-name containing data
DAT <- read.csv(FILE)
DAT <- na.omit(DAT)

#Create Report Directory
dir.create(RPRT.DIR)

#Set working directory to Report Directory
RPRT.DIR <- paste(WD, RPRT.DIR, sep = "/")
setwd(RPRT.DIR)

DAT.LEN <- DAT$MP.test %>% length()
OUT.LMT <- DAT.LEN * 0.05
OUT.MAX <- floor(OUT.LMT)

ESD.RESLT <- rosnerTest(DAT$MP.test, OUT.MAX) %>% as.list()
ESD.RESLT$all.stats <- ESD.RESLT$all.stats %>% kable()

# Save report
sink("Outlier_Result.txt")
paste("Total data number:", DAT.LEN, sep = " ")
paste("Upper limite of outlier numbers:", OUT.MAX, sep = " ")
ESD.RESLT$all.stats
sink()
