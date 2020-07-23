#Part 0. Preparations: configuration area
#Load package needed
Packages <- c("dplyr", "ggplot2", "chemCal")
lapply(Packages, library, character.only = TRUE)

DIR <- "analysis"
setwd("~")
WD <- getwd()
WD <- paste(WD, DIR, sep = "/")
setwd(WD)

#Read setting for analysis
SET <- read.csv("setting.csv")
alpha <- SET$EP17.Alpha

beta <- SET$EP17.Beta
probit.goal <- beta
#Configuration for figures to be exported
FIG_W_CM <- SET$FIG_W_CM #Figure width in cm
FIG_H_CM <- SET$FIG_H_CM #Figure height in cm
FIG_DPI <- SET$FIG_DPI #Figure resolution

#Read data and assign as DAT data.frame
FILE <- "data.csv" #file-name containing data
DAT <- read.csv(FILE)
DAT <- na.omit(DAT)

#remove y=0
DAT <- DAT %>% filter(y > 0 )

lob.log.lst <- c()
DAT.SPL <- DAT %>% split(DAT$Reagent_Lot)



for (X in DAT.SPL){
  Reagent_Lot <- X$Reagent_Lot[1]
  fig.name <- paste("Plot_analysis_for_Reagent_Lot", Reagent_Lot, "png", sep = ".")
  X$log.conc <- log10(X$Concentration)
  fit <- lm(y ~ log.conc, data = X)
  
  #save regression report
  report.name <- paste("Regression_analysis_for_Reagent_Lot", Reagent_Lot, "txt", sep = ".")
  sink(report.name)
  fit %>% summary() %>% print()
  sink()
  
  #reverse calculate log[conc]
  rslt <- inverse.predict(fit, probit.goal)
  lod.log.lst <- c(lob.log.lst, rslt$Prediction)
  
  P1 <- ggplot(X, aes(x = log.conc, y = y)  ) +
    geom_point() +
    geom_smooth(method = "lm") + 
    geom_hline(yintercept = probit.goal, linetype = 2)
  
  ggsave(fig.name,
         plot = P1,
         units = "cm",
         width = FIG_W_CM,
         height = FIG_H_CM,
         dpi = FIG_DPI) #save as .png file
}

lob.lst <- 10 ^ lob.log.lst
lob.final <- max(lob.lst)

sink("Probit_regression_for_LoB.txt")
print("LoB for each Reagent Lot is:")
print(lod.lst)
print("The final LoB is:")
print(lod.final)
sink()