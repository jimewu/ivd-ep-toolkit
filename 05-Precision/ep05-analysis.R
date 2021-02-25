#Load package needed
Packages <- c("dplyr", "ggplot2", "VCA", "knitr")
lapply(Packages, library, character.only = TRUE)

#Set working directory using rstudioapi

DIR <- dirname(rstudioapi::getSourceEditorContext()$path)
TIME <- format(Sys.time(), "%Y-%m%d-%H%M%S")
RPRT.DIR <- paste("Report", TIME, sep = "_")
setwd(DIR)

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

#Create Report Directory
dir.create(RPRT.DIR)

#Set working directory to Report Directory
RPRT.DIR <- paste(WD, RPRT.DIR, sep = "/")
setwd(RPRT.DIR)

#for precision estimates
#Draw Levey-Jennings chart
MN <- mean(DAT$y)
SD <- sd(DAT$y)
DAT$y.sd <- (DAT$y - MN) / SD #Calculate y in scale of SD

Var3.YN <- factor(DAT$Var3) %>% levels() %>% length()


if (Var3.YN == 1){
  #Scatterplot in original scale
  P1 <- DAT %>% ggplot(aes(x = Var1) ) +
    geom_point(aes(y = y, 
                   color = factor(Var2) )) + 
    labs(title = "Measurement results", 
         color = "Var2") +
    theme(plot.title = element_text(hjust = 0.5)) #Center title
  
  #Levey Jennings plot
  LJ <- DAT %>% ggplot(aes(x = Var1) ) +
    geom_point(aes(y = y.sd, 
                   color = factor(Var2) ) ) + 
    labs(title = "Levey-Jennings", 
         color = "Var2",
         y = "SD") +
    theme(plot.title = element_text(hjust = 0.5)) #Center title
  
}else{
  #Scatterplot in original scale
  P1 <- DAT %>% ggplot(aes(x = Var1) ) +
    geom_point(aes(y = y, 
                   color = factor(Var2), 
                   shape = factor(Var3) )) + 
    labs(title = "Measurement results", 
         color = "Var2", 
         shape = "Var3") +
    theme(plot.title = element_text(hjust = 0.5)) #Center title
  
  #Levey Jennings plot
  LJ <- DAT %>% ggplot(aes(x = Var1) ) +
    geom_point(aes(y = y.sd, 
                   color = factor(Var2), 
                   shape = factor(Var3) ) ) + 
    labs(title = "Levey-Jennings", 
         color = "Var2", 
         shape = "Var3", 
         y = "SD") +
    theme(plot.title = element_text(hjust = 0.5)) #Center title
}

if (Var3.YN == 1){
  #Calculate result of nested ANOVA of day/run
  RSLT <- anovaVCA(y~Var1/Var2,DAT)
}else{
  RSLT <- anovaVCA(y~Var1/Var2/Var3,DAT)
}


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

if (Var3.YN == 1){
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
}else{
  CV.V3 <- RSLT[4,7]
  
  if (CV.V3 <= 100 * Acceptance_Criteria){
    RPRT.V3 <- paste("%CV of Var3 <= acceptance critera:", 
                      100 * Acceptance_Criteria,
                      "% (PASS)", sep = "")
  }else{
    RPRT.V3 <- paste("%CV of Var3 > acceptance critera:", 
                      100 * Acceptance_Criteria,
                      "% (FAIL)", sep = "")
  }
  
  CV.REP <- RSLT[5,7]
  
  if (CV.REP <= 100 * Acceptance_Criteria){
    RPRT.REP <- paste("%CV of Replicate <= acceptance critera:", 
                      100 * Acceptance_Criteria,
                      "% (PASS)", sep = "")
  }else{
    RPRT.REP <- paste("%CV of Replicate > acceptance critera:", 
                      100 * Acceptance_Criteria,
                      "% (FAIL)", sep = "")
  }
}



#Save plots
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
RPRT.total %>% print()
RPRT.V1 %>% print()
RPRT.V2 %>% print()
if (Var3.YN != 1){
  RPRT.V3 %>% print()
}
RPRT.REP %>% print()
print("==========================Result of ANOVA==========================")
RSLT
print("=====================Confidence Interval in SD=====================")
INTF$ConfInt$SD
print("=====================Confidence Interval in %CV=====================")
INTF$ConfInt$CV
print("============================End of Report============================")
sink()