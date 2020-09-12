#Part 0. Preparations: configuration area
#Load package needed
Packages <- c("dplyr", "ggplot2", "Rmisc", "knitr")
lapply(Packages, library, character.only = TRUE)

#Set working directory
DIR <- "ivd-ep-toolkit/07-Interference"
TIME <- format(Sys.time(), "%Y-%m%d-%H%M%S")
RPRT.DIR <- paste("Report_for_Paired_Difference", TIME, sep = "_")
setwd("~")
WD <- getwd()
WD <- paste(WD, DIR, sep = "/")
setwd(WD)

#Read setting for analysis
SET <- read.csv("setting.csv")
alpha <- SET$EP7.Alpha
al_intf <- SET$EP7.Allowable_interference
al_intf_perc <- al_intf * 100


#Configuration for figures to be exported
FIG_W_CM <- SET$FIG_W_CM #Figure width in cm
FIG_H_CM <- SET$FIG_H_CM #Figure height in cm
FIG_DPI <- SET$FIG_DPI #Figure resolution

#Read data and assign as DAT data.frame
FILE <- "data.csv" #file-name containing data
DAT <- read.csv(FILE)
DAT <- na.omit(DAT)

#Split DAT by Sample and calculate CI for Diff and Diff.p
DAT.SPL <- DAT %>% split(DAT$Sample)

RPRT1 <- data.frame()
RPRT2 <- data.frame()

for (X in DAT.SPL){
  Sample <- X$Sample[1]
  #Separate by group
  X.control <- X %>% filter(Group == "control")
  X.test <- X %>% filter(Group == "test")
  
  #Calculate mean & sd
  y.control.mean <- mean(X.control$y)
  y.control.sd <- sd(X.control$y)
  y.test.mean <- mean(X.test$y)
  y.test.sd <- sd(X.test$y)
  
  #Calculate diff  
  y.diff <- y.test.mean - y.control.mean
  y.diff.perc <- 100 * y.diff / y.control.mean
  
  #calculate CI
  n.control <- length(X.control$y)
  n.test <- length(X.test$y)
  df <- n.control + n.test - 2
  tv <- qt(1-alpha/2, df)
  ci <- tv * ( y.control.sd^2/n.control +  y.test.sd^2/n.test )^0.5
  ci.perc <- 100 * ci / y.control.mean
  
  #calculate LCI, UCI
  y.diff.lci <- y.diff - ci
  y.diff.uci <- y.diff + ci
  y.diff.perc.lci <- y.diff.perc - ci.perc
  y.diff.perc.uci <- y.diff.perc + ci.perc
  
  RSLT1 <- c(Sample,
            y.control.mean, y.control.sd,
            y.test.mean, y.test.sd,
            y.diff, y.diff.lci, y.diff.uci)
  
  RSLT2 <- c(Sample,
             y.control.mean, y.control.sd,
             y.test.mean, y.test.sd,
             y.diff.perc, y.diff.perc.lci, y.diff.perc.uci)
  
  RPRT1 <- rbind(RPRT1, RSLT1)
  RPRT2 <- rbind(RPRT2, RSLT2)

}

colnames(RPRT1) <- c("Sample_Name", "Control_Mean", "Control_SD", 
                     "Test_Mean", "Test_SD",
                     "Diff", "Diff_LCI", "Diff_UCI")
colnames(RPRT2) <- c("Sample_Name", "Control_Mean", "Control_SD", 
                     "Test_Mean", "Test_SD",
                     "%DIFF", "%Diff_LCI", "%Diff_UCI")

# Determine if Dose Response should be performed by the maximal of %DIFF
max_diff <- RPRT2$`%DIFF` %>% as.numeric() %>% abs() %>% max()

if (max_diff <= al_intf_perc){
  MSG <- "Maximal %Difference is smaller than allowable interference, thus no need to perform dose response."
}else{
  MSG <- "Maximal %Difference is larger than allowable interference, thus dose response should be performed."
}


## Save report files
#Create working directory
dir.create(RPRT.DIR)

#Set working directory
RPRT.DIR <- paste(WD, RPRT.DIR, sep = "/")
setwd(RPRT.DIR)

# Generate report
sink("Paired_Difference_Report.txt")
paste("As per setting.csv, current allowalbe interference is:", 
      al_intf_perc, "%", SEP = " ") %>% print()
RPRT1 %>% kable()
RPRT2 %>% kable()
print("")
print("")
MSG
sink()
