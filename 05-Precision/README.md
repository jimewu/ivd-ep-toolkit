# 使用說明

## 準備檔案

- 在example資料夾找到所需要的setting.csv以及data.csv範例檔案，複製到程式資料夾"05-Precision"底下。
- 目前example資料夾中的檔案已經填入數值，可以用於執行相應程式並產生報告，但使用者應參考附錄"欄位說明"替換成自己的設定/數值。

## 執行程式 & 觀看報告

- 執行ep05-analysis.R
- 報告會出現在程式資料夾底下的"Report\_YYYY-MMDD-HHMMSS"資料夾下
- 報告內容依序如下:
	+ Measurement_Results.png: 原始結果作圖(X: Var1; Y: 測量值)，不同的Var2會以不同顏色顯示，不同的Replicate會以不同形狀顯示
	+ Levey-Jennings.png: 同Measurement_Results.png，但Y改為標準差
	+ Report.txt: 結果彙整，包含:
		* Summary: 各項參數有無通過setting.csv中設定之Acceptance Critera (EP5.Acceptance_Criteria)
		* Result of ANOVA: nested ANOVA結果
		* Confidence Interval in SD: 以SD表示的信心區間
		* Confidence Interval in %CV: 以%CV表示的新新區間

# 附錄: 欄位說明

## setting.csv

說明: 各欄位應該依照使用者實際需求修改

- FIG\_W\_CM: 報告的圖表寬度(單位為公分)
- FIG\_H\_CM: 報告的圖表高度(單位為公分)
- FIG\_DPI: 報告的圖表解析度(單位DPI)
- EP5.Acceptance_Criteria: 允收基準，預設為0.05 (i.e., 5%)

## data.csv

基本說明: 第一列是標題列，請勿更改。第二列起每一列是一筆資料，因此若有80筆結果就應該有80列。各欄位說明如下:

- Var1: 試驗設計中的1st參數，例如在3 Lots * 20 Days * 2 Runs中，Var1就代表Lot
- Var2:試驗設計中的2nd參數，例如在3 Lots * 20 Days * 2 Runs中，Var2就代表Day
- Var3: 試驗設計中的3rd參數，例如在3 Lots * 20 Days * 2 Runs中，Var3就代表Run
	+ **如果只有實驗中只有兩個變數，則填入Var1以及Var2，同時Var3保持都是1即可**
	+ **Var1, Var2, Var3均相同的多筆資料即為不同replicates，因此不需要額外輸入"Replicate"這個變數**
- y: 該次的測量值