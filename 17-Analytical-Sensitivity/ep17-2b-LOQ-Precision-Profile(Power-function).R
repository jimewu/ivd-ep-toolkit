#Part 0. Preparations: configuration area
#Load package needed
Packages <- c("dplyr", "ggplot2", "chemCal")
lapply(Packages, library, character.only = TRUE)

#Set working directory
DIR <- "ivd-ep-toolkit/17-Analytical-Sensitivity"
TIME <- format(Sys.time(), "%Y-%m%d-%H%M%S")
RPRT.DIR <- paste("Report_for_LOQ-Precision-Profile", TIME, sep = "_")
setwd("~")
WD <- getwd()
WD <- paste(WD, DIR, sep = "/")
setwd(WD)

#Read setting for analysis
SET <- read.csv("setting.csv")
CV.goal <- SET$EP17.CV.goal
CV.goal <- CV.goal * 100
CV.goal.log <- log10(CV.goal)

#Configuration for figures to be exported
FIG_W_CM <- SET$FIG_W_CM #Figure width in cm
FIG_H_CM <- SET$FIG_H_CM #Figure height in cm
FIG_DPI <- SET$FIG_DPI #Figure resolution

#Read data and assign as DAT data.frame
FILE <- "data.csv" #file-name containing data
DAT <- read.csv(FILE)
DAT <- na.omit(DAT)
DAT$CV <- 100 * DAT$SD.WL / DAT$Mean

#Create Report Directory
dir.create(RPRT.DIR)

#Set working directory to Report Directory
RPRT.DIR <- paste(WD, RPRT.DIR, sep = "/")
setwd(RPRT.DIR)

LOT <- c()
LOQ <- c()


DAT.SPL <- split(DAT, DAT$Reagent_Lot)
for (X in DAT.SPL){
  Reagent_Lot <- X$Reagent_Lot[1]
  fit <- lm(log10(CV)~log10(Mean), data = X)
  fit.sum <- fit %>% summary()
  x.goal.log <- inverse.predict(fit, newdata = CV.goal.log)
  x.goal <- 10 ^ x.goal.log$Prediction
  
  RGS.RPRT.NAME <- paste("Regression_Report_for_Lot",Reagent_Lot,".txt", sep = "")
  sink(RGS.RPRT.NAME)
  fit.sum %>% print()
  sink()
  
  LOT <- c(LOT, Reagent_Lot)
  LOQ <- c(LOQ, x.goal)

}
RPRT.LOQ <- data.frame(Reagent_Lot = LOT,
                       LoQ_within_Lot = LOQ)
LOQ.FINAL <- LOQ %>% max()


sink("LOQ_Result.txt")
paste("The goal for %CV of LoQ is:", CV.goal, "%", sep=" ")
print("LoQ result in each reagent lot using power function:")
RPRT.LOQ
print("the final LoQ is:")
LOQ.FINAL
sink()

P1 <- ggplot(DAT,aes(x=log(Mean), y=log(CV), 
                     color=factor(Reagent_Lot),
                     linetype = factor(Reagent_Lot)) ) +
  geom_point() + 
  geom_smooth(method="lm", se = FALSE, alpha = 0.5) +
  labs(title = "Precision Profiles with log-transformation",
       x = "log(Measurand Concentration)",
       y = "log(%CV)",
       color = "Reagent_Lot",
       linetype = "Reagent_Lot")

ggsave("Precision-profile.png",
       plot = P1,
       units = "cm",
       width = FIG_W_CM,
       height = FIG_H_CM,
       dpi = FIG_DPI) #save as .png file