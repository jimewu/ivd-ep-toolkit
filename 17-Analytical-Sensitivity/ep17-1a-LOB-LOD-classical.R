#Part 0. Preparations: configuration area
#Load package needed
Packages <- c("dplyr", "ggplot2", "knitr")
lapply(Packages, library, character.only = TRUE)

#Set working directory using rstudioapi
DIR <- dirname(rstudioapi::getSourceEditorContext()$path)
TIME <- format(Sys.time(), "%Y-%m%d-%H%M%S")
RPRT.DIR <- paste("Report", TIME, sep = "_")
setwd(DIR)

#Read setting for analysis
SET <- read.csv("setting.csv")
alpha <- SET$EP17.Alpha
PCTB <- (1- alpha) #依照指定的Alpha來算出Percentile PCTB

#Configuration for figures to be exported
FIG_W_CM <- SET$FIG_W_CM #Figure width in cm
FIG_H_CM <- SET$FIG_H_CM #Figure height in cm
FIG_DPI <- SET$FIG_DPI #Figure resolution

#Read data and assign as DAT data.frame
FILE <- "data.csv" #file-name containing data
DAT <- read.csv(FILE)
DAT <- na.omit(DAT)

#Create Report Directory
dir.create(RPRT.DIR)

#Set working directory to Report Directory
RPRT.DIR <- paste(WD, RPRT.DIR, sep = "/")
setwd(RPRT.DIR)



#Part 1. LoB部份
DAT_BLANK <- DAT %>% filter(Sample_Type == "Blank") #分離出Blank資料

DAT_BLANK_SPL <- DAT_BLANK %>% split(DAT_BLANK$Reagent_Lot) #依照Lot分開
LOB <- c() #初始化一個空的值

#以Shapiro-Wilk test判斷Blank資料與常態分佈有無顯著差異?
SPW <- shapiro.test(DAT_BLANK$y) %>% as.list()

if (SPW$p.value < 0.05){
  #非常態分佈
  RPRT0_LOT <- c()
  RPRT0_LOB <- c()
  
  #對每個Lot進行計算LoB
  for (BLANK_1L in DAT_BLANK_SPL){
    LOT <- BLANK_1L$Reagent_Lot %>% factor() %>% levels() 
    
    Sample_N <- length(BLANK_1L$y)
    RNK <- 0.5 + Sample_N * PCTB
    RNK1 <- floor(RNK) #無條件捨去
    RNK2 <- ceiling(RNK) #無條件進位
    
    DAT_SRT <- sort(BLANK_1L$y) #把資料升冪排序
    LOB_1L <- (DAT_SRT[RNK1] + DAT_SRT[RNK2]) / 2 #取平均
    LOB <- c(LOB, LOB_1L) #加進結果
    
    #結果加入報告中
    RPRT0_LOT <- c(RPRT0_LOT, LOT)
    RPRT0_LOB <- c(RPRT0_LOB, LOB_1L)
  }
  MSG = "The Blank data is not normally distributed (Shapiro-Wilk test p-value <0.05)"
  RPRT0 <- data.frame(Lot = RPRT0_LOT,
                      LoB = RPRT0_LOB)
  
}else{
  #常態分佈
  RPRT0_LOT <- c()
  RPRT0_MEAN <- c()
  RPRT0_SD <- c()
  RPRT0_CP <- c()
  RPRT0_LOB <- c()
  
  #對每個Lot進行計算LoB
  for (BLANK_1L in DAT_BLANK_SPL){
    
    LOT <- BLANK_1L$Reagent_Lot %>% factor() %>% levels() 
    MEAN <- BLANK_1L$y %>% mean()
    SD <- BLANK_1L$y %>% sd()
    
    #Calculate CP = 1.645 / (1 - (1/(4*(L-J)) ))
    #L is total data numbers
    #J is number of low level samples
    L <- length(BLANK_1L$y)
    J <- BLANK_1L$Sample_Name %>% factor() %>% levels() %>% length()
    CP <- qnorm(1-alpha) / ( 1- (1/(4*(L-J))  ) )
    
    LOB_1L <- MEAN + CP * SD
    LOB <- c(LOB, LOB_1L) #加進結果

    #結果加入報告中
    RPRT0_LOT <- c(RPRT0_LOT, LOT)
    RPRT0_MEAN <- c(RPRT0_MEAN, MEAN)
    RPRT0_SD <- c(RPRT0_SD, SD)
    RPRT0_CP <- c(RPRT0_CP, CP)
    RPRT0_LOB <- c(RPRT0_LOB, LOB_1L)
  }
  MSG = "The Blank data is normally distributed (Shapiro-Wilk test p-value >=0.05)"
  RPRT0 <- data.frame(Lot = RPRT0_LOT,
                      Mean = RPRT0_MEAN,
                      SD = RPRT0_SD,
                      CP = RPRT0_CP,
                      LoB = RPRT0_LOB)
}

LOB_F <- max(LOB) #取最大的那個最為最終LoB



#Part 2. LoD部份
DAT_LOW <- DAT %>% filter(Sample_Type == "Low") #分離出Low資料

#加入一欄是Reagent_Lot加上Sample_Name方面後面分組
DAT_LOW <- DAT_LOW %>% mutate(LOT_NAME = paste(Reagent_Lot, Sample_Name, sep = "_"))

DAT_LOW_SPL <- DAT_LOW %>% split(DAT_LOW$LOT_NAME) #依照LOT_NAME拆分

#初始化空的報告
RPRT_Sample_Name <- c()
RPRT_Reagent_Lot <- c()
RPRT_N <- c()
RPRT_SD <- c()

#分組運算
for (X in DAT_LOW_SPL){
  SN <- X$Sample_Name %>% factor %>% levels()
  RL <- X$Reagent_Lot %>% factor() %>% levels()
  NUM <- length(X$y)
  SD <- sd(X$y)
  
  #加入報告中
  RPRT_Sample_Name <- c(RPRT_Sample_Name, SN)
  RPRT_Reagent_Lot <- c(RPRT_Reagent_Lot, RL)
  RPRT_N <- c(RPRT_N, NUM)
  RPRT_SD <- c(RPRT_SD, SD)
}

#組合報告
RPRT_LOD <- data.frame(Sample_Name = RPRT_Sample_Name,
                   Reagent_Lot = RPRT_Reagent_Lot,
                   N = RPRT_N,
                   SD = RPRT_SD)


DAT2 <- RPRT_LOD
DAT2$A <- (DAT2$N -1) * DAT2$SD^2
DAT2$B <- DAT2$N -1

DAT2_SPL <- DAT2 %>% split(DAT2$Reagent_Lot)


#每個Reagent_Lot分組計算
LOD <- c() #初始化一個空的值

#初始化空的報告
RPRT2_LOT <- c()
RPRT2_SDL <- c()
RPRT2_CP <- c()
RPRT2_LOD <- c()

for (X in DAT2_SPL){
  LOT <- X$Reagent_Lot %>% factor() %>% levels()
  SDL <- (sum(X$A) / sum(X$B)) %>% sqrt()
  
  #Calculate CP = 1.645 / (1 - (1/(4*(L-J)) ))
  #L is total data numbers
  #J is number of low level samples
  L <- X$N %>% sum()
  J <- length(X$Sample_Name)
  CP <- qnorm(1-alpha) / ( 1- (1/(4*(L-J))  ) )
  
  LOD_1L <- LOB_F + CP * SDL
  LOD <- c(LOD, LOD_1L)

  #加入報告中
  RPRT2_LOT <- c(RPRT2_LOT, LOT)
  RPRT2_SDL <- c(RPRT2_SDL, SDL)
  RPRT2_CP <- c(RPRT2_CP, CP)
  RPRT2_LOD <- c(RPRT2_LOD, LOD_1L)
}

#取最大的LoD最為最終LoD
LOD_F <- max(LOD)



#組合報告
RPRT_LOD2 <- data.frame(Reagent_Lot = RPRT2_LOT,
                       SDL = RPRT2_SDL,
                       CP = RPRT2_CP,
                       LOD = RPRT2_LOD)

RPRT1 <- RPRT0 %>% kable()
RPRT_LOD.k <- RPRT_LOD %>% kable()
RPRT_LOD2.k <- RPRT_LOD2 %>% kable()

#輸出報告
sink("Classical_LOB_LOD_Report.txt")
Sys.Date()
print("Part 1. LoB Report")
print(MSG)
print("LoB for each lot:")
print(RPRT1)
paste("Final LoB:", LOB_F)
print("=========================================")
print("Part 2. LoD Report")
print("Result for each sample in each lot:")
print(RPRT_LOD.k)
print("")
print("Result for each lot:")
print(RPRT_LOD2.k)
print("")
print("LoD for each lot:")
print(LOD)
paste("Final LoD:", LOD_F)
sink()
write.csv(RPRT0, file = "Classical_LOB_Sample_Report.csv")
write.csv(RPRT_LOD, file = "Classical_LOD_Sample_Report.csv")
write.csv(RPRT_LOD2, file = "Classical_LOD_Sample_Report2.csv")