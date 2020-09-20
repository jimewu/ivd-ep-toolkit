# 使用說明

## 準備檔案

- 在"example2a\_LOQ-Total-Error"資料夾找到所需要的setting.csv範例檔案，複製到程式資料夾"07-Interference"底下。
- 目前example資料夾中的檔案已經填入數值，可以用於執行相應程式並產生報告，但使用者應參考附錄"欄位說明"替換成自己的設定/數值。

## 執行程式 & 觀看報告

- 執行"ep17-2a1-LOQ-Total\_Error-RMS.R"或是"ep17-2a2-LOQ-Total\_Error-Westgard.R"
- 報告會出現在程式資料夾底下的"Report\_for\_LOQ-Total-Error-RMS\_YYYY-MMDD-HHMMSS"資料夾或是""Report\_for\_LOQ-Total-Error-Westgard\_YYYY-MMDD-HHMMSS""下
-  依據報告結果:
	+ LoQ_Report.csv: 原始結果
	+ LoQ_Plot.png: 原始結果作圖 (X: 參考方法濃度; Y: Total Error)，不同批次以不同顏色的點呈現，藍色線條為線性回歸，虛線為setting.csv中設定之目標Total Error (EP17.TE.goal)
	+ LoQ_Report.txt: 結果匯總，包含計算之達到目標Total Error時的濃度值

# 附錄: 欄位說明

## setting.csv

說明: 各欄位應該依照使用者實際需求修改

- FIG\_W\_CM: 報告的圖表寬度(單位為公分)。
- FIG\_H\_CM: 報告的圖表高度(單位為公分)。
- FIG\_DPI: 報告的圖表解析度(單位DPI)。
- EP17.TE.goal: 目標Total Error，預設為0.216 (21.6%)

## data.csv

基本說明: 第一列是標題列，請勿更改。第二列起每一列是一筆資料，因此若有80筆結果就應該有80列。各欄位說明如下:

- Day: 測量時的天數
- Replicate: 該次測試為第幾次重複
- Sample_Type: 樣品類型為空白樣品 (填入Blank)或是低濃度樣品 (填入Low)
- Sample_Name: 樣品名稱，例如為第一個空白樣品(填入B1)，或是第三個低濃度樣品 (填入L3)
- Reagent_Lot: 使用的reagent批次
- y: 測量值
- Ref: 該樣品參考方法的測量值，同一樣品的值應該相同





