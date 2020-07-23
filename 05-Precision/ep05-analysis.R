#Part 0. Preparations: configuration area
#Load package needed
Packages <- c("dplyr", "ggplot2", "VCA", "knitr")
lapply(Packages, library, character.only = TRUE)

DIR <- "analysis"
setwd("~")
WD <- getwd()
WD <- paste(WD, DIR, sep = "/")
setwd(WD)

#Read setting for analysis
SET <- read.csv("setting.csv")
Acceptance_Criteria = SET$EP5.Acceptance_Criteria


#Configuration for figures to be exported
FIG_W_CM <- SET$FIG_W_CM #Figure width in cm
FIG_H_CM <- SET$FIG_H_CM #Figure height in cm
FIG_DPI <- SET$FIG_DPI #Figure resolution

#Read data and assign as DAT data.frame
FILE <- "data.csv" #file-name containing data
DAT <- read.csv(FILE)
DAT <- na.omit(DAT)

#for precision estimates
#Draw Levey-Jennings chart
MN <- mean(DAT$y)
SD <- sd(DAT$y)
DAT$y.sd <- (DAT$y - MN) / SD

P1 <- DAT %>% ggplot(aes(x = Var1) ) +
  geom_point(aes(y = y, color = factor(Var2), shape = factor(Rep) )) + 
  labs(title = "Measurement results", shape = "Replicate", color = "Var2") +
  theme(plot.title = element_text(hjust = 0.5))

LJ <- DAT %>% ggplot(aes(x = Var1) ) +
  geom_point(aes(y = y.sd, color = factor(Var2), shape = factor(Rep) ) ) + 
  labs(title = "Levey-Jennings", shape = "Replicate", 
       color = "Var2", y = "SD") +
  theme(plot.title = element_text(hjust = 0.5))

ggsave("Measurement_Results.png", 
       plot = P1,
       units = "cm",
       width = FIG_W_CM,
       height = FIG_H_CM,
       dpi = FIG_DPI) #save as .png file

ggsave("Levey-Jennings.png", 
       plot = LJ,
       units = "cm",
       width = FIG_W_CM,
       height = FIG_H_CM,
       dpi = FIG_DPI) #save as .png file

#nested ANOVA of day/run
RSLT <- anovaVCA(y~Var1/Var2,DAT)

#calculate confidence interval
INTF <- VCAinference(RSLT)

sink("Report_SD_CV.txt")
RSLT
sink()

sink("Report_CI.txt")
INTF
sink()


