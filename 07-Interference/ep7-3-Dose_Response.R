#Part 0. Preparations: configuration area
#Load package needed
Packages <- c("dplyr", "ggplot2", "Rmisc", "knitr", "chemCal")
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
AI <- SET$EP7.Allowable_interference

#Configuration for figures to be exported
FIG_W_CM <- SET$FIG_W_CM #Figure width in cm
FIG_H_CM <- SET$FIG_H_CM #Figure height in cm
FIG_DPI <- SET$FIG_DPI #Figure resolution

#Read data and assign as DAT data.frame
FILE <- "data.csv" #file-name containing data
DAT <- read.csv(FILE)
DAT <- na.omit(DAT)


#find mean of sample of no Interferent_Added
DAT0 <- DAT %>% filter(Interferent_Added == 0)
M0 <- DAT0$y %>% mean()

#form empty report
RPRT1 <- c()

#split by Interferent_Added
DAT.SPL <- DAT %>% split(DAT$Sample)

#process each sample
for (X in DAT.SPL){
  Sample <- X$Sample[1]
  Mean <- X$y %>% mean()
  SD <- X$y %>% sd()
  CV <- 100*SD/Mean
  INTF_AD <- X$Interferent_Added[1]
  Diff <- Mean - M0
  Perc_Diff <- 100*Diff/M0
  
  RSLT <- c(Sample, Mean, CV, INTF_AD, Diff, Perc_Diff)
  
  RPRT1 <- rbind(RPRT1, RSLT)
}

colnames(RPRT1) <- c("Sample", "Mean", "CV", 
                     "Interferent_Added", "Diff", "Perc_Diff")

RPRT1 <- as.data.frame(RPRT1)

#check for monotonicity
order.intf <- RPRT1[order(RPRT1$Interferent_Added),]
order.mean <- RPRT1[order(RPRT1$Mean),]
mono <- all.equal(order.intf, order.mean)

#linear regression
fit.lm <- lm(y ~ Interferent_Added, DAT)
fit.sum <- fit.lm  %>% summary()

#check direction and significance of linear regression
direction <- fit.sum$coefficients[1,1]
sig.regs <- fit.sum$coefficients[2,4]



# y.goal <- M0 *(1+AI)
order <- order(RPRT1$Interferent_Added)
RPRT1.inc <- RPRT1[order,]

if (sig.regs < 0.05 && direction >0){
  #positive linear interference
  y.goal <- M0 *(1+AI)
  
  #draw plot
  P1 <- ggplot(RPRT1, aes(x = Interferent_Added, y = Mean)) +
    geom_smooth(alpha = 0.5, method = "lm") +
    geom_point(data = DAT, aes(y = y)  ) +
    geom_hline(yintercept = y.goal, linetype = 2  )+
    scale_y_continuous(sec.axis = sec_axis(~. * 100/M0 - 100, 
                                           name = "Percent Difference") ) +
    labs(x= "Interferent Added", y="Measurand level")
  
  x.goal <- inverse.predict(fit.lm, newdata = y.goal)
  x.goal <- x.goal$Prediction
  
  msg <- "線性回歸顯著(p<0.05)，干擾方向為正向"
  msg2 <- paste("以線性回歸推測干擾物濃度為:", x.goal, "以內不超過Allowable Interference:",AI, sep = " ")
  
}else if(sig.regs < 0.05 && direction <0){
  #negative linear interference
  y.goal <- M0 *(1-AI)
  
  #draw plot
  P1 <- ggplot(RPRT1, aes(x = Interferent_Added, y = Mean)) +
    geom_smooth(alpha = 0.5, method = "lm") +
    geom_point(data = DAT, aes(y = y)  ) +
    geom_hline(yintercept = y.goal, linetype = 2  )+
    scale_y_continuous(sec.axis = sec_axis(~. * 100/M0 - 100, 
                                           name = "Percent Difference") ) +
    labs(x= "Interferent Added", y="Measurand level")
  
  x.goal <- inverse.predict(fit.lm, newdata = y.goal)
  x.goal <- x.goal$Prediction
  
  msg <- "線性回歸顯著(p<0.05)，干擾方向為負向"
  msg2 <- paste("以線性回歸推測干擾物濃度為:", x.goal, "以內不超過Allowable Interference:",AI, sep = " ")
  
  
}else if(dircection > 0){
  #positive non-linear interference
  y.goal <- M0 *(1+AI)
  
  #draw scatter plot
  P1 <- ggplot(RPRT1, aes(x = Interferent_Added, y = Mean)) +
    geom_line(alpha = 0.5) +
    geom_point(data = DAT, aes(y = y)  ) +
    geom_hline(yintercept = y.goal, linetype = 2  )+
    scale_y_continuous(sec.axis = sec_axis(~. * 100/M0 - 100, 
                                           name = "Percent Difference") ) +
    labs(x= "Interferent Added", y="Measurand level")
  
  
  #find the smallest bigger
  up <- RPRT1.inc$Mean > y.goal
  up <- RPRT1.inc[up,] %>% head(1)
  
  #find biggest smaller
  down <- RPRT1.inc$Mean < y.goal
  down <- RPRT1.inc[down,] %>% tail(1)
  
  slope <- (up$Mean -down$Mean)/(up$Interferent_Added - down$Interferent_Added)
  y.add <- y.goal - down$Mean
  x.add <- y.add / slope
  
  x.goal <- down$Interferent_Added + x.add
  
  msg <- "線性回歸不顯著(p>=0.05)，干擾方向為正向"
  msg2 <- paste("以point-to-point推測干擾物濃度為:", x.goal, "以內不超過Allowable Interference:",AI, sep = " ")
  
  
}else if(direction < 0){
  #negative non-linear interference
  y.goal <- M0 *(1-AI)
  
  #draw scatter plot
  P1 <- ggplot(RPRT1, aes(x = Interferent_Added, y = Mean)) +
    geom_line(alpha = 0.5) +
    geom_point(data = DAT, aes(y = y)  ) +
    geom_hline(yintercept = y.goal, linetype = 2  )+
    scale_y_continuous(sec.axis = sec_axis(~. * 100/M0 - 100, 
                                           name = "Percent Difference") ) +
    labs(x= "Interferent Added", y="Measurand level")
  
  
  #find the smallest bigger
  up <- RPRT1.inc$Mean > y.goal
  up <- RPRT1.inc[up,] %>% tail(1)
  
  #find biggest smaller
  down <- RPRT1.inc$Mean < y.goal
  down <- RPRT1.inc[down,] %>% head(1)
  
  slope <- (down$Mean - up$Mean)/(down$Interferent_Added - up$Interferent_Added)
  # slope <- (up$Mean -down$Mean)/(up$Interferent_Added - down$Interferent_Added)
  y.add <- y.goal - up$Mean
  x.add <- y.add / slope
  
  x.goal <- up$Interferent_Added + x.add
  
  msg <- "線性回歸不顯著(p>=0.05)，干擾方向為負向"
  msg2 <- paste("以point-to-point推測干擾物濃度為:", x.goal, "以內不超過Allowable Interference:",AI, sep = " ")
  
}

## Save report files
#Create working directory
dir.create(RPRT.DIR)

#Set working directory
RPRT.DIR <- paste(WD, RPRT.DIR, sep = "/")
setwd(RPRT.DIR)

# Generate report
sink("Dose_Response_Analysis_Result.txt")
msg
msg2
print("線性回歸報告：")
fit.sum
sink()

ggsave("Dose_Response_Analysis_Result.png", 
       plot = P1,
       units = "cm",
       width = FIG_W_CM,
       height = FIG_H_CM,
       dpi = FIG_DPI) #save as .png file