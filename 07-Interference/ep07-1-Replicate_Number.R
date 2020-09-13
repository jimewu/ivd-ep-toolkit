#Part 0. Preparations: configuration area
#Load package needed
Packages <- c("dplyr", "ggplot2", "Rmisc", "knitr")
lapply(Packages, library, character.only = TRUE)

#Set working directory
DIR <- "ivd-ep-toolkit/07-Interference"
TIME <- format(Sys.time(), "%Y-%m%d-%H%M%S")
RPRT.DIR <- paste("Report_for_Replicate_Number", TIME, sep = "_")
setwd("~")
WD <- getwd()
WD <- paste(WD, DIR, sep = "/")
setwd(WD)


#Read setting for analysis
SET <- read.csv("setting.csv")
alpha <- SET$EP7.Alpha
beta <- SET$EP7.Beta
rtio <- SET$EP7.MP_rep / SET$EP7.Allowable_interference

#Create Report Directory
dir.create(RPRT.DIR)

#Set working directory to Report Directory
RPRT.DIR <- paste(WD, RPRT.DIR, sep = "/")
setwd(RPRT.DIR)

#2-sided
N.2s <- 2 * ((qnorm(1-alpha/2) + qnorm(1-beta)) * rtio )^2
if (N.2s >= 5){
  N.2s <- ceiling(N.2s)
}else{
  N.2s <- 5
}

#1-sided
N.1s <- 2 * ( (qnorm(1-alpha) + qnorm(1-beta) ) * rtio )^2
if (N.1s >= 5){
  N.1s <- ceiling(N.1s)
}else{
  N.1s <- 5
}

# Save report
sink("Determine_Replicate_Number.txt")
paste("for two-sided test: N =", N.2s, sep = " ")
paste("for one-sided test: N =", N.1s, sep = " ")
sink()