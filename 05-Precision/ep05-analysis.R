#Load package needed
Packages <- c("dplyr", "ggplot2", "VCA", "knitr")
lapply(Packages, library, character.only = TRUE)

#Set working directory
DIR <- "ivd-ep-toolkit/05-Precision"
TIME <- format(Sys.time(), "%Y-%m%d-%H%M%S")
RPRT.DIR <- paste("Report", TIME, sep = "_")
setwd("~")
WD <- getwd()
WD <- paste(WD, DIR, sep = "/")
setwd(WD)

#Read setting for analysis
SET <- read.csv("setting.csv") #setting file name
Acceptance_Criteria = SET$EP5.Acceptance_Criteria

#Configure specs for figures to be exported
FIG_W_CM <- SET$FIG_W_CM #Figure width in cm
FIG_H_CM <- SET$FIG_H_CM #Figure height in cm
FIG_DPI <- SET$FIG_DPI #Figure resolution

#Read data and assign as DAT data.frame
FILE <- "data.csv" #specify file-name containing data
DAT <- read.csv(FILE) #read file and set as DAT
DAT <- na.omit(DAT) #remove NA values

#for precision estimates
#Draw Levey-Jennings chart
MN <- mean(DAT$y)
SD <- sd(DAT$y)
DAT$y.sd <- (DAT$y - MN) / SD #Calculate y in scale of SD

#Scatterplot in original scale
P1 <- DAT %>% ggplot(aes(x = Var1) ) +
  geom_point(aes(y = y, 
                 color = factor(Var2), 
                 shape = factor(Rep) )) + 
  labs(title = "Measurement results", 
       shape = "Replicate", 
       color = "Var2") +
  theme(plot.title = element_text(hjust = 0.5)) #Center title

#Levey Jennings plot
LJ <- DAT %>% ggplot(aes(x = Var1) ) +
  geom_point(aes(y = y.sd, 
                 color = factor(Var2), 
                 shape = factor(Rep) ) ) + 
  labs(title = "Levey-Jennings", 
       shape = "Replicate", 
       color = "Var2", 
       y = "SD") +
  theme(plot.title = element_text(hjust = 0.5)) #Center title

#Calculate result of nested ANOVA of day/run
RSLT <- anovaVCA(y~Var1/Var2,DAT)

#calculate confidence interval
INTF <- VCAinference(RSLT)

#Convert RSLT to matrix
RSLT <- RSLT %>% as.matrix.VCA
CV.total <- RSLT[1,7]
if (CV.total <= 100 * Acceptance_Criteria){
  RPRT.total <- paste("Total %CV <= acceptance critera:", 
                      100 * Acceptance_Criteria,
                      "% (PASS)", sep = "")
}else{
  RPRT.total <- paste("Total %CV > acceptance critera:", 
                      100 * Acceptance_Criteria,
                      "% (FAIL)", sep = "")
}

CV.V1 <- RSLT[2,7]
if (CV.V1 <= 100 * Acceptance_Criteria){
  RPRT.V1 <- paste("%CV of Var1 <= acceptance critera:", 
                      100 * Acceptance_Criteria,
                      "% (PASS)", sep = "")
}else{
  RPRT.V1 <- paste("%CV of Var1 > acceptance critera:", 
                      100 * Acceptance_Criteria,
                      "% (FAIL)", sep = "")
}

CV.V2 <- RSLT[3,7]
if (CV.V2 <= 100 * Acceptance_Criteria){
  RPRT.V2 <- paste("%CV of Var2 <= acceptance critera:", 
                   100 * Acceptance_Criteria,
                   "% (PASS)", sep = "")
}else{
  RPRT.V2 <- paste("%CV of Var2 > acceptance critera:", 
                   100 * Acceptance_Criteria,
                   "% (FAIL)", sep = "")
}

CV.REP <- RSLT[4,7]
if (CV.REP <= 100 * Acceptance_Criteria){
  RPRT.REP <- paste("%CV of Replicate <= acceptance critera:", 
                   100 * Acceptance_Criteria,
                   "% (PASS)", sep = "")
}else{
  RPRT.REP <- paste("%CV of Replicate > acceptance critera:", 
                   100 * Acceptance_Criteria,
                   "% (FAIL)", sep = "")
}


## Save report files
#Create working directory
dir.create(RPRT.DIR)

#Set working directory
RPRT.DIR <- paste(WD, RPRT.DIR, sep = "/")
setwd(RPRT.DIR)

#Save plot using specs as setting
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

sink("Report.txt")
print("=============================Summary=============================")
RPRT.total
RPRT.V1
RPRT.V2
RPRT.REP
print("==========================Result of ANOVA==========================")
RSLT
print("=====================Confidence Interval in SD=====================")
INTF$ConfInt$SD
print("=====================Confidence Interval in %CV=====================")
INTF$ConfInt$CV
print("============================End of Report============================")
sink()