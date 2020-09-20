# 使用說明

## 準備檔案

- 在"example1b_LOD-Probit"資料夾找到所需要的setting.csv以及data.csv範例檔案，複製到程式資料夾"17-Analytical-Sensitivity"底下。
- 目前example資料夾中的檔案已經填入數值，可以用於執行相應程式並產生報告，但使用者應參考附錄"欄位說明"替換成自己的設定/數值。

## 執行程式 & 觀看報告

- 執行"ep17-1b-LOD-Probit.R"
- 報告會出現在程式資料夾底下的"Report\_for\_LOD-Probit\_YYYY-MMDD-HHMMSS"資料夾下
-  依據報告結果:
	+ 單一批次結果: 例如Lot1會有"Plot\_analysis\_for\_Reagent\_Lot.1.png"以及"Regression\_analysis\_for\_Reagent\_Lot.1.txt"兩個檔案，分別是該批次的圖檔(X: 濃度取log; Y: 該濃度多次測量出現陽性的機率(Hit Rate); 藍色線條為線性回歸，虛線為)
	+ 匯總結果: 參見"Probit\_regression\_for\_LOD.txt"，包含單一批次之LOD以及最終之LOD

# 附錄: 欄位說明

## setting.csv

說明: 各欄位應該依照使用者實際需求修改

- FIG\_W\_CM: 報告的圖表寬度(單位為公分)。
- FIG\_H\_CM: 報告的圖表高度(單位為公分)。
- FIG\_DPI: 報告的圖表解析度(單位DPI)。
- EP17.Alpha: type-I error，預設為0.05 (i.e., 5%)
- EP17.Beta: type-II error，預設為0.05 (i.e., 5%)

## data.csv

基本說明: 第一列是標題列，請勿更改。第二列起每一列是一筆資料，因此若有80筆結果就應該有80列。各欄位說明如下:

- Concentration: 該樣品濃度。並無預設濃度單位，但是所有同欄位之數值應該使用同單位
- Reagent_Lot: 使用的reagent批次
- y: 測量值