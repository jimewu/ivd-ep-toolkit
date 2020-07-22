#Part 0. Preparations: configuration area
#Load package needed
Packages <- c("dplyr", "ggplot2", "ggExtra", "EnvStats", "knitr", "mcr")
lapply(Packages, library, character.only = TRUE)

DIR <- "analysis"
setwd("~")
WD <- getwd()
WD <- paste(WD, DIR, sep = "/")
setwd(WD)

#Read setting for analysis
SET <- read.csv("setting.csv")

#Configuration for figures to be exported
FIG_W_CM <- SET$FIG_W_CM #Figure width in cm
FIG_H_CM <- SET$FIG_H_CM #Figure height in cm
FIG_DPI <- SET$FIG_DPI #Figure resolution

#Read data and assign as DAT data.frame
FILE <- "data.csv" #file-name containing data
DAT <- read.csv(FILE)
DAT <- na.omit(DAT)

#Scatter plot
PLT.SC <- ggplot(DAT,aes(x=MP.comp, y=MP.test)  ) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "Scatter Plot",x = "Comparative Method", y = "Testing Method") +
  theme(plot.title = element_text(hjust = 0.5))

ggsave("Scatter_Plot.png", 
       plot = PLT.SC,
       units = "cm",
       width = FIG_W_CM,
       height = FIG_H_CM,
       dpi = FIG_DPI) #save as .png file


#Plot difference with marginal
DAT$Diff <- DAT$MP.test - DAT$MP.comp
DAT$Diff.P <- DAT$Diff / DAT$MP.comp

PLT.Diff <- ggplot(DAT,aes(x = MP.comp, y = Diff)  ) +
  geom_point() +
  geom_hline(yintercept = mean(DAT$Diff), linetype = 2, color = "red") +
  labs(title = "Difference Plot",x = "Measuring level of Comparative Method", y = "Difference") +
  theme(plot.title = element_text(hjust = 0.5))

PLT.Diff.Mg.D <- ggMarginal(PLT.Diff, margins = 'y', type = "density", fill = "gray")
PLT.Diff.Mg.H <- ggMarginal(PLT.Diff, margins = 'y', type = "histogram", fill = "gray")

PLT.Diff.P <- ggplot(DAT,aes(x = MP.comp, y = Diff.P)  ) +
  geom_point() +
  geom_hline(yintercept = mean(DAT$Diff), linetype = 2, color = "red") +
  labs(title = "Difference Plot",x = "Measuring level of Comparative Method", y = "%Difference") +
  theme(plot.title = element_text(hjust = 0.5))

PLT.Diff.P.Mg.D <- ggMarginal(PLT.Diff.P, margins = 'y', type = "density", fill = "gray")
PLT.Diff.P.Mg.H <- ggMarginal(PLT.Diff.P, margins = 'y', type = "histogram", fill = "gray")

ggsave("Difference_Plot_Marginal.png", 
       plot = PLT.Diff.Mg.D,
       units = "cm",
       width = FIG_W_CM,
       height = FIG_H_CM,
       dpi = FIG_DPI) #save as .png file

ggsave("Difference_Plot_Marginal_Histogram.png", 
       plot = PLT.Diff.Mg.H,
       units = "cm",
       width = FIG_W_CM,
       height = FIG_H_CM,
       dpi = FIG_DPI) #save as .png file

ggsave("Percent_Difference_Plot_Marginal.png", 
       plot = PLT.Diff.P.Mg.D,
       units = "cm",
       width = FIG_W_CM,
       height = FIG_H_CM,
       dpi = FIG_DPI) #save as .png file

ggsave("Percent_Difference_Plot_Marginal_Histogram.png", 
       plot = PLT.Diff.P.Mg.H,
       units = "cm",
       width = FIG_W_CM,
       height = FIG_H_CM,
       dpi = FIG_DPI) #save as .png file

#Method Comparison
err.rto <- SET$EP9.Error_Ratio

fit.olr <- mcreg(x = DAT$MP.comp, y = DAT$MP.test,
                 error.ratio = err.rto,
                 alpha = SET$EP9.alpha,
                 method.reg = "LinReg",
                 method.ci = "analytical",
                 mref.name = "Comparative Method",
                 mtest.name = "Testing Method",
                 na.rm = TRUE)

fit.deming <- mcreg(x = DAT$MP.comp, y = DAT$MP.test,
                    error.ratio = err.rto,
                    alpha = SET$EP9.alpha,
                    method.reg = "Deming",
                    method.ci = "analytical",
                    mref.name = "Comparative Method",
                    mtest.name = "Testing Method",
                    na.rm = TRUE)

fit.wolr <- mcreg(x = DAT$MP.comp, y = DAT$MP.test,
                 error.ratio = err.rto,
                 alpha = SET$EP9.alpha,
                 method.reg = "WLinReg",
                 method.ci = "analytical",
                 mref.name = "Comparative Method",
                 mtest.name = "Testing Method",
                 na.rm = TRUE)

fit.wdeming <- mcreg(x = DAT$MP.comp, y = DAT$MP.test,
                    error.ratio = err.rto,
                    alpha = SET$EP9.alpha,
                    method.reg = "WDeming",
                    method.ci = "jackknife",
                    mref.name = "Comparative Method",
                    mtest.name = "Testing Method",
                    na.rm = TRUE)

fit.paba <- mcreg(x = DAT$MP.comp, y = DAT$MP.test,
                     error.ratio = err.rto,
                     alpha = SET$EP9.alpha,
                     method.reg = "PaBa",
                     method.ci = "bootstrap",
                     mref.name = "Comparative Method",
                     mtest.name = "Testing Method",
                     na.rm = TRUE)

pdf(file = "Summary_of_All_Regression.pdf")
compareFit(fit.olr, fit.deming, fit.wolr, fit.wdeming, fit.paba)
dev.off()

#Regression reports
#Points to calculate bias
PTS <- c(max(DAT$MP.comp ),
         min(DAT$MP.comp) )

sink("(OLR)Regression_Summary.txt")
printSummary(fit.olr)
print("------------------------------------------")
print("Bias for highest and lowest measurement values")
calcBias(fit.olr, x.levels = PTS)
sink()

sink("(Deming)Regression_Summary.txt")
printSummary(fit.deming)
print("------------------------------------------")
print("Bias for highest and lowest measurement values")
calcBias(fit.deming, x.levels = PTS)
sink()

sink("(Weighted_OLR)Regression_Summary.txt")
printSummary(fit.wolr)
print("------------------------------------------")
print("Bias for highest and lowest measurement values")
calcBias(fit.wolr, x.levels = PTS)
sink()

sink("(Weighted_Deming)Regression_Summary.txt")
printSummary(fit.wdeming)
print("------------------------------------------")
print("Bias for highest and lowest measurement values")
calcBias(fit.wdeming, x.levels = PTS)
sink()

sink("(Passing-Bablok)Regression_Summary.txt")
printSummary(fit.paba)
print("------------------------------------------")
print("Bias for highest and lowest measurement values")
calcBias(fit.paba, x.levels = PTS)
sink()

#Regression plots
pdf(file = "(OLR)Regression_Plot.pdf")
plot(fit.olr)
dev.off()

pdf(file = "(Deming)Regression_Plot.pdf")
plot(fit.deming)
dev.off()

pdf(file = "(Weighted_OLR)Regression_Plot.pdf")
plot(fit.wolr)
dev.off()

pdf(file = "(Weighted_Deming)Regression_Plot.pdf")
plot(fit.wdeming)
dev.off()

pdf(file = "(Passing-Bablok)Regression_Plot.pdf")
plot(fit.paba)
dev.off()

#Bias plots
pdf(file = "(OLR)Bias_Plot.pdf")
plotBias(fit.olr)
dev.off()

pdf(file = "(Deming)Bias_Plot.pdf")
plotBias(fit.deming)
dev.off()

pdf(file = "(Weighted_OLR)Bias_Plot.pdf")
plotBias(fit.wolr)
dev.off()

pdf(file = "(Weighted_Deming)Bias_Plot.pdf")
plotBias(fit.wdeming)
dev.off()

pdf(file = "(Passing-Bablok)Bias_Plot.pdf")
plotBias(fit.paba)
dev.off()