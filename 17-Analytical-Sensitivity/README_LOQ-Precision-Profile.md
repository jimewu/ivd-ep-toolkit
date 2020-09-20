# 使用說明

## 準備檔案

- 在"example2b\_LOQ-Precision-Profile"資料夾找到所需要的setting.csv範例檔案，複製到程式資料夾"07-Interference"底下。
- 目前example資料夾中的檔案已經填入數值，可以用於執行相應程式並產生報告，但使用者應參考附錄"欄位說明"替換成自己的設定/數值。

## 執行程式 & 觀看報告

- 執行"ep17-2b-LOQ-Precision-Profile(Power-function).R"
- 報告會出現在程式資料夾底下的"Report\_for\_LOQ-Precision-Profile\_YYYY-MMDD-HHMMSS"資料夾下
-  依據報告結果:
	+ 單批次結果: 例如Lot1，其線性回歸結果可以參見"Regression\_Report\_for\_Lot1.txt"
	+ 作圖: 參見"Precision-profile.png" (X: 分析物濃度取log, Y: %CV取log)
	+ 結果匯總: 參見"LOQ_Result.txt"，包含單一批次計算出之單批次LOQ，以及最終LOQ

# 附錄: 欄位說明

## setting.csv

說明: 各欄位應該依照使用者實際需求修改

- FIG\_W\_CM: 報告的圖表寬度(單位為公分)。
- FIG\_H\_CM: 報告的圖表高度(單位為公分)。
- FIG\_DPI: 報告的圖表解析度(單位DPI)。
- EP17.CV.goal: 目標%CV，預設為0.1 (10%)

## data.csv

基本說明: 第一列是標題列，請勿更改。第二列起每一列是一筆資料，因此若有80筆結果就應該有80列。各欄位說明如下:

- Sample_Name: 樣品名稱，例如為第一個混合樣品(填入Pool 1)
- Reagent_Lot: 使用的reagent批次
- Mean: 該樣品測量的平均值
- SD.WL: 該樣品依據ep5算出的within-lab precision