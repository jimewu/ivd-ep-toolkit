#Part 0. Preparations: configuration area
#Load package needed
Packages <- c("dplyr", "ggplot2")
lapply(Packages, library, character.only = TRUE)

DIR <- "analysis"
setwd("~")
WD <- getwd()
WD <- paste(WD, DIR, sep = "/")
setwd(WD)

#Read setting for analysis
SET <- read.csv("setting.csv")
Allowable_Drift = SET$EP25.Allowable_drift

#Configuration for figures to be exported
FIG_W_CM <- SET$FIG_W_CM #Figure width in cm
FIG_H_CM <- SET$FIG_H_CM #Figure height in cm
FIG_DPI <- SET$FIG_DPI #Figure resolution

#Read data and assign as DAT data.frame
FILE <- "data.csv" #file-name containing data
DAT <- read.csv(FILE)
DAT <- na.omit(DAT)

#Part 1. Polynomial regression of each sample
DAT_LST <- DAT %>% split(DAT$Sample) #Split DAT into list by Sample

#Use loop to process data one by one

for (DAT1 in DAT_LST){
RPRT <- list() #Create an empty report
RPRT$Sample_Name <- factor(DAT1$Sample) %>% levels() #Add Sample name to report

#Linear regression
RGS <- lm(y ~ Day, DAT1)
RPRT$Regression_Result <- summary(RGS) #Add Summary of regression to report
SIG <- RPRT$Regression_Result$coefficients[2,4]
SLOPE <- RPRT$Regression_Result$coefficients[2,1]

#if Regression is in-significant, only export regression report,
#if else, draw plot and find intercept
if (SIG >= 0.05){
  #Report Regression Results
  RPRT$Report_Name <- paste("(_Sample", RPRT$Sample_Name, ")", "Regression_Analysis_Report.txt", sep = "_")
  sink(RPRT$Report_Name)
  paste("Sample:", RPRT$Sample_Name) %>% print()
  print(RPRT$Regression_Result)
  paste("Regression for Sample:", RPRT$Sample_Name, "is not significant (p >= 0.05).") %>% print()
  print("Analysis of this sample ends here.")
  sink()
}else if(SLOPE >0){
  #1. Use linear regression to calculate y,upper CI, and lower CI of each day
  D_MAX <- max(DAT1$Day) #Find max day number within data
  D_RANGE <- data.frame(Day = c(1:D_MAX) ) #Form day range: 1 to max day
  
  PRDT <- predict(RGS, newdata = D_RANGE, interval = "confidence") #Calculate for everyday
  PRDT <- as.data.frame(PRDT) #Change type for later processing
  PRDT <- cbind(D_RANGE, PRDT) #Add Day as the first column
  
  #1-2. Find data with upr <= allowable drift
  R0 <- DAT1 %>% filter(Day == 0) #Find the row when Day is 0
  y0 <- R0$y #Find the y of Day0
  y_upper <- y0 * (1 + Allowable_Drift) #The limit with allowable drift
  PRDT_OK <- PRDT %>% filter(upr <= y_upper)
  D_MAX <- max(PRDT_OK$Day) #Find max day number within data
  
  #1-3. Report Regression Results
  RPRT$Report_Name <- paste("(_Sample", RPRT$Sample_Name, ")", "Regression_Analysis_Report.txt", sep = "_")
  sink(RPRT$Report_Name)
  paste("Sample:", RPRT$Sample_Name) %>% print()
  print(RPRT$Regression_Result)
  paste("Maximal Day number with allowable drift is:", D_MAX) %>% print
  sink()
  
  #2. Visual examination of regression with upper limit line of allowable drift
  P1 <- ggplot(DAT1,aes(x = Day, y = y)  ) +
    geom_point() + 
    geom_smooth(method = "lm") + 
    geom_hline(linetype = 2, yintercept = y_upper, color = "#00AFBB") +
    geom_text(mapping = aes(0, y_upper, label = y_upper, vjust = -1, hjust = -0.1) )
  
  RPRT$Report_Name <- paste("(_Sample", RPRT$Sample_Name, ")", "Regression_Analysis_Plot.png", sep = "_")
  ggsave(RPRT$Report_Name, 
         plot = P1,
         units = "cm",
         width = FIG_W_CM,
         height = FIG_H_CM,
         dpi = FIG_DPI) #save as .png file
  
}else if(SLOPE <0){
  #1. Use linear regression to calculate y,upper CI, and lower CI of each day
  D_MAX <- max(DAT1$Day) #Find max day number within data
  D_RANGE <- data.frame(Day = c(1:D_MAX) ) #Form day range: 1 to max day

  PRDT <- predict(RGS, newdata = D_RANGE, interval = "confidence") #Calculate for everyday
  PRDT <- as.data.frame(PRDT) #Change type for later processing
  PRDT <- cbind(D_RANGE, PRDT) #Add Day as the first column

  #1-2. Find data with upr <= allowable drift
  R0 <- DAT1 %>% filter(Day == 0) #Find the row when Day is 0
  y0 <- R0$y #Find the y of Day0
  y_lower <- y0 * (1 - Allowable_Drift) #The limit with allowable drift
  PRDT_OK <- PRDT %>% filter(lwr >= y_lower)
  D_MAX <- max(PRDT_OK$Day) #Find max day number within data

  #1-3. Report Regression Results
  RPRT$Report_Name <- paste("(_Sample", RPRT$Sample_Name, ")", "Regression_Analysis_Report.txt", sep = "_")
  sink(RPRT$Report_Name)
  paste("Sample:", RPRT$Sample_Name) %>% print()
  print(RPRT$Regression_Result)
  paste("Maximal Day number with allowable drift is:", D_MAX) %>% print
  sink()

  #2. Visual examination of regression with upper limit line of allowable drift
  P1 <- ggplot(DAT1,aes(x = Day, y = y)  ) +
    geom_point() +
    geom_smooth(method = "lm") +
    geom_hline(linetype = 2, yintercept = y_lower, color = "#00AFBB") +
    geom_text(mapping = aes(0, y_lower, label = y_lower, vjust = -1, hjust = -0.1) )

  RPRT$Report_Name <- paste("(_Sample", RPRT$Sample_Name, ")", "Regression_Analysis_Plot.png", sep = "_")
  ggsave(RPRT$Report_Name,
         plot = P1,
         units = "cm",
         width = FIG_W_CM,
         height = FIG_H_CM,
         dpi = FIG_DPI) #save as .png file
}
}