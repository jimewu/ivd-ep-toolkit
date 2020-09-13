#Part 0. Preparations: configuration area
#Load package needed
Packages <- c("dplyr", "ggplot2", "chemCal")
lapply(Packages, library, character.only = TRUE)

#Set working directory
DIR <- "ivd-ep-toolkit/17-Analytical-Sensitivity"
TIME <- format(Sys.time(), "%Y-%m%d-%H%M%S")
RPRT.DIR <- paste("Report_for_LOQ-Total-Error-RMS", TIME, sep = "_")
setwd("~")
WD <- getwd()
WD <- paste(WD, DIR, sep = "/")
setwd(WD)

#Read setting for analysis
SET <- read.csv("setting.csv")
TE.goal <- SET$EP17.TE.goal
TE.goal <- TE.goal * 100

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

#Part 1. 依照Sample_Name * Reagent_Lot分組
DAT$Name.Lot <- paste(DAT$Sample_Name, DAT$Reagent_Lot)
DAT.SPL <- DAT %>% split(DAT$Name.Lot)


TB1.REF <- c()
TB1.LOT <- c()
TB1.SN <- c()
TB1.MN <- c()
TB1.SD <- c()


for (X in DAT.SPL){
  OBS.REF <- X$Ref[1]
  OBS.LOT <- X$Reagent_Lot[1]
  OBS.SN <- X$Sample_Name[1]

  OBS.MN <- mean(X$y)
  OBS.SD <- sd(X$y)
  
  TB1.REF <- c(TB1.REF, OBS.REF)
  TB1.LOT <- c(TB1.LOT, OBS.LOT)
  TB1.SN <- c(TB1.SN, OBS.SN)
  TB1.MN <- c(TB1.MN, OBS.MN)
  TB1.SD <- c(TB1.SD, OBS.SD)
}

TB1 <- data.frame(TB1.REF, TB1.LOT, TB1.SN, TB1.MN, TB1.SD)
colnames(TB1) <- c("REF", "LOT", "SN", "MN", "SD")
TB1$BIAS <- TB1$MN - TB1$REF
TB1$TE <- 100*(((TB1$BIAS)^2 + (TB1$SD)^2)^0.5)/TB1$REF


TE.fit <- lm(TE ~ REF, TB1)
TE.predict.goal <- inverse.predict(TE.fit, TE.goal)
TE.predict.y0 <- inverse.predict(TE.fit, 0)


#Draw plot
colnames(TB1) <- c("Reference_Level", "Reagent_Lot", "Sample_Name", "Mean", "SD", "Bias", "TE")
write.csv(TB1, file = "LoQ_Report.csv")

sink("LoQ_Report.txt")
print("Prediction of Measurement Level when its TE meets goal:")
print("(Lowest level of potential LoQ)")
TE.predict.goal$Prediction %>% print()
sink()

TE.plot <- TB1 %>% ggplot(aes(x = Reference_Level, y = TE) ) +
  geom_point(aes(color = factor(Reagent_Lot) ) ) +
  stat_smooth(method = "lm", fullrange = TRUE, se = FALSE) +
  geom_hline(yintercept = TE.goal, linetype = 2) +
  xlim(0, TE.predict.y0$Prediction)

ggsave("LoQ_Plot.png",
       plot = TE.plot,
       units = "cm",
       width = FIG_W_CM,
       height = FIG_H_CM,
       dpi = FIG_DPI) #save as .png file