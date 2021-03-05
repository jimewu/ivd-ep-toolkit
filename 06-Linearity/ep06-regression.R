#Part 0. Preparations: configuration area
#Load package needed
Packages <- c("dplyr", "ggplot2", "here")
lapply(Packages, library, character.only = TRUE)

#Set working directory using rsudioapi
DIR <- dirname(rstudioapi::getSourceEditorContext()$path)
TIME <- format(Sys.time(), "%Y-%m%d-%H%M%S")
RPRT.DIR <- paste("Report", TIME, sep = "_")
setwd(DIR)

#Read setting for analysis
SET <- read.csv("setting.csv")
#Acceptance_Criteria for differences in linear regression
Acceptance_Criteria = SET$EP6.Acceptance_Criteria
N.RND <- SET$Max.Digit

#Configuration for figures to be exported
FIG_W_CM <- SET$FIG_W_CM #Figure width in cm
FIG_H_CM <- SET$FIG_H_CM #Figure height in cm
FIG_DPI <- SET$FIG_DPI #Figure resolution

#Read data and assign as DAT data.frame
FILE <- "data.csv" #file-name containing data
DAT <- read.csv(FILE)

#Create Report Directory
dir.create(RPRT.DIR)

#Set working directory to Report Directory
RPRT.DIR <- paste(WD, RPRT.DIR, sep = "/")
setwd(RPRT.DIR)

#Part 1. Polynomial regression
RGS1 <- lm(y ~ poly(dilution, 1, raw = TRUE), DAT) #1st order regression
RGS2 <- lm(y ~ poly(dilution, 2, raw = TRUE), DAT) #2nd order regression
RGS3 <- lm(y ~ poly(dilution, 3, raw = TRUE), DAT) #3rd order regression

DAT <- DAT %>% mutate(P1 = predict(RGS1),
                      P2 = predict(RGS2),
                      P3 = predict(RGS3))

#Split DAT by Dilution
Table_1st_vs_2nd <- data.frame()

DAT.SPL <- split(DAT, DAT$dilution)

for (X in DAT.SPL){
  Dilution <- X$dilution[1]
  y.Mean <- X$y %>% mean()
  y.Diff <- max(X$y) - min(X$y)
  y.Diff.SQ <- y.Diff ^ 2
  y.Perc.Diff <- 100 * y.Diff / y.Mean
  y.Perc.Diff.SQ <- y.Perc.Diff ^ 2
  Regression.1st <- mean(X$P1)
  Regression.2nd <- mean(X$P2)
  Regression.Diff = Regression.2nd - Regression.1st
  Regression.Perc.Diff <- 100 * Regression.Diff / Regression.1st
  Regression_Diff_H_Goal <- Regression.1st * Acceptance_Criteria
  Regression_Diff_L_Goal <- Regression_Diff_H_Goal * -1
  
  RSLT <- c(Dilution, y.Mean, y.Diff, y.Diff.SQ, 
            y.Perc.Diff, y.Perc.Diff.SQ,
            Regression.1st, Regression.2nd,
            Regression.Diff, Regression.Perc.Diff,
            Regression_Diff_H_Goal, Regression_Diff_L_Goal)
  Table_1st_vs_2nd <- rbind(Table_1st_vs_2nd, RSLT)
}


colnames(Table_1st_vs_2nd) <- c("Dilution", "Mean", 
                                "Difference", "SQDF",
                                "Perc_D", "SQ_Perc_D",
                                "Predicted_1st", "Predicted_2nd",
                                "Regression_Diff", "Regression_Perc_Diff",
                                "Regression_Diff_H_Goal", 
                                "Regression_Diff_L_Goal")

POOL.RP <- Table_1st_vs_2nd %>% summarize(Pooled_Repeatability = sqrt(mean(SQ_Perc_D)))
colnames(POOL.RP) <- c("Pooled_Repeatability(%)")

RPRT.T1V2 <- Table_1st_vs_2nd
colnames(RPRT.T1V2) <- c("Dilution", "y.Mean", "y.Diff", "y.Squared_Diff",
                                "y.%Diff", "y.Squared_%Diff", "Regression.1st",
                                "Regression.2nd", "Regression.Diff",
                                "Regression.%Diff", "Regression.upper_Criteria",
                                "Regression.lower_Criteria")

Table_1st_vs_3rd <- data.frame()

for (X in DAT.SPL){
  Dilution <- X$dilution[1]
  y.Mean <- X$y %>% mean()
  y.Diff <- max(X$y) - min(X$y)
  y.Diff.SQ <- y.Diff ^ 2
  y.Perc.Diff <- 100 * y.Diff / y.Mean
  y.Perc.Diff.SQ <- y.Perc.Diff ^ 2
  Regression.1st <- mean(X$P1)
  Regression.3rd <- mean(X$P3)
  Regression.Diff = Regression.3rd - Regression.1st
  Regression.Perc.Diff <- 100 * Regression.Diff / Regression.1st
  Regression_Diff_H_Goal <- Regression.1st * Acceptance_Criteria
  Regression_Diff_L_Goal <- Regression_Diff_H_Goal * -1
  
  RSLT <- c(Dilution, y.Mean, y.Diff, y.Diff.SQ, 
            y.Perc.Diff, y.Perc.Diff.SQ,
            Regression.1st, Regression.3rd,
            Regression.Diff, Regression.Perc.Diff,
            Regression_Diff_H_Goal, Regression_Diff_L_Goal)
  Table_1st_vs_3rd <- rbind(Table_1st_vs_3rd, RSLT)
}

colnames(Table_1st_vs_3rd) <- c("Dilution", "Mean", 
                                "Difference", "SQDF",
                                "Perc_D", "SQ_Perc_D",
                                "Predicted_1st", "Predicted_3rd",
                                "Regression_Diff", "Regression_Perc_Diff",
                                "Regression_Diff_H_Goal", 
                                "Regression_Diff_L_Goal")

RPRT.T1V3 <- Table_1st_vs_3rd

colnames(RPRT.T1V3) <- c("Dilution", "y.Mean", "y.Diff", "y.Squared_Diff",
                                "y.%Diff", "y.Squared_%Diff", "Regression.1st",
                                "Regression.3rd", "Regression.Diff",
                                "Regression.%Diff", "Regression.upper_Criteria",
                                "Regression.lower_Criteria")

#Part 3. Draw regression plots
#P1 is basic data with 1st order regression
P1 <- ggplot(DAT, aes(x = dilution) ) + 
  geom_point(aes(y = y)) +
  geom_smooth(aes(y = predict(RGS1), color = "1st" )  )

#Add 2nd order regression as P1_vs_2
P1_vs_2 <- P1 +
  geom_smooth(aes(y = predict(RGS2), color = "2nd"), linetype=2) +
  labs(x = "Relative Concentration", y = "Measurement Value",color = "Regression")

P1_vs_3 <- P1 +
  geom_smooth(aes(y = predict(RGS3), color = "3rd"), linetype=2) + 
  labs(x = "Relative Concentration", y = "Measurement Value",color = "Regression")

#Part 4. Draw difference plot
D1_vs_2 <- ggplot(Table_1st_vs_2nd, aes(x = Mean) ) + 
  geom_point(aes(y = Regression_Diff, fill = "Difference")) +
  geom_line(aes(y = Regression_Diff_H_Goal, color = "High Goal"), linetype = 2 ) +
  geom_line(aes(y = Regression_Diff_L_Goal, color = "Low Goal"), linetype = 2 ) +
  labs(title = "Difference Plot: 1st VS 2nd", y = "Difference of Regression", fill = "", color = "Acceptance Criteria")

D1_vs_3 <- ggplot(Table_1st_vs_3rd, aes(x = Mean) ) + 
  geom_point(aes(y = Regression_Diff, fill = "Difference")) +
  geom_line(aes(y = Regression_Diff_H_Goal, color = "High Goal"), linetype = 2 ) +
  geom_line(aes(y = Regression_Diff_L_Goal, color = "Low Goal"), linetype = 2 ) +
  labs(title = "Difference Plot: 1st VS 3rd", y = "Difference of Regression", fill = "", color = "Acceptance Criteria")

## Save report files
sink("(1st)Results_of_Regression_Analysis.txt") #save to .txt file
summary(RGS1)
sink()

sink("(2nd)Results_of_Regression_Analysis.txt") #save to .txt file
summary(RGS2)
sink()

sink("(3rd)Results_of_Regression_Analysis.txt") #save to .txt file
summary(RGS3)
sink()

sink("(QC)Sample_Pooled_Repeatability.txt")
print(POOL.RP)
sink()

#set maximal number of digits after the dot according to N.RND
RPRT.T1V2 <- RPRT.T1V2 %>% round(N.RND)
RPRT.T1V3 <- RPRT.T1V3 %>% round(N.RND)

write.csv(RPRT.T1V2,
          file = "(1st_vs_2nd)Table.csv") #export as .csv file

write.csv(RPRT.T1V3,
          file = "(1st_vs_3rd)Table.csv") #export as .csv file

ggsave("(1st_vs_2nd)Linearity_Study.png",
       plot = P1_vs_2,
       units = "cm",
       width = FIG_W_CM,
       height = FIG_H_CM,
       dpi = FIG_DPI) #save as .png file

ggsave("(1st_vs_3rd)Linearity_Study.png",
       plot = P1_vs_3,
       units = "cm",
       width = FIG_W_CM,
       height = FIG_H_CM,
       dpi = FIG_DPI) #save as .png file

ggsave("(1st_vs_2nd)Difference_Plot.png",
       plot = D1_vs_2,
       units = "cm",
       width = FIG_W_CM,
       height = FIG_H_CM,
       dpi = FIG_DPI) #save as .png file

ggsave("(1st_vs_3rd)Difference_Plot.png",
       plot = D1_vs_3,
       units = "cm",
       width = FIG_W_CM,
       height = FIG_H_CM,
       dpi = FIG_DPI) #save as .png file