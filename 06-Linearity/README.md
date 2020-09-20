# 使用說明

## 準備檔案

- 在example資料夾找到所需要的setting.csv以及data.csv範例檔案，複製到程式資料夾"06-Linearity"底下。
- 目前example資料夾中的檔案已經填入數值，可以用於執行相應程式並產生報告，但使用者應參考附錄"欄位說明"替換成自己的設定/數值。

## 執行程式 & 觀看報告

- 執行ep06-regression.R
- 報告會出現在程式資料夾底下的"Report\_YYYY-MMDD-HHMMSS"資料夾下
- 報告內容依序如下:
	- (QC)Sample\_Pooled\_Repeatability.txt: 不同repeat之間的repeatability計算結果，須自行決定是否符合設定的標準，若符合則可繼續分析
	- 單一多項式分析: 一共有3個檔案，分別是"(1st)Results_of_Regression_Analysis.txt", "(2nd)Results_of_Regression_Analysis.txt", "(3rd)Results_of_Regression_Analysis.txt"，分別代表將結果做一次多項式(1st), 二次多項式(2nd), 三次多項式(3rd)回歸的結果。每個檔案中的Coefficients裡面含有回歸的結果表格，各列說明如下:
		- (Intercept): 截距的結果，Estimate為估計值，Std. Error為標準差，Pr(>|t|) 為其顯著性(一般< 0.05表示顯著，即標注為*)
		- poly(dilution, 1, raw = TRUE): 一次多項式的斜率，各欄位說明與截距類似。
		- 其餘在二級/三級多項式回歸中以此類推，各欄位說明均類似。
		- 這個部份的重點在於確認一級多項式結果為顯著，並找出顯著的非線性多項式(2nd 或 3rd)
	- 多項式對比: 例如是1級多項式與2級多項式對比，則有以下檔案:
		+ (1st_vs_2nd)Linearity_Study.png: 將兩個多項式結果一起成現在同一圖中(X: 相對濃度; Y: 測量值)，並用不同顏色以及線條(實線/虛線)顯示。
		+ (1st_vs_2nd)Difference_Plot.png: 兩個多項式的差異以點呈現在圖中 (X: 測量值平均; Y: 多項式差異)，並以虛線畫出依據setting.csv中設定的允收基準(EP6.Acceptance\_Criteria)，也就是最大的non-linearity上下線。
		+ (1st_vs_2nd)Table.csv: 多項式對比原始結果

# 附錄: 欄位說明

## setting.csv

說明: 各欄位應該依照使用者實際需求修改

- FIG\_W\_CM: 報告的圖表寬度(單位為公分)
- FIG\_H\_CM: 報告的圖表高度(單位為公分)
- FIG\_DPI: 報告的圖表解析度(單位DPI)
- Max.Digit: 報告中數值的小數位數，預設為3
- EP6.Acceptance_Criteria: 允收基準，預設為0.05 (i.e., 5% non-linearity)

## data.csv

基本說明: 第一列是標題列，請勿更改。第二列起每一列是一筆資料，因此若有80筆結果就應該有80列。各欄位說明如下:

- dilution: 樣品的相對濃度值，例如6個樣品分別濃度為1x, 2x, 3x, 4x, 5x, 6x，則分別填入1, 2, 3, 4, 5, 6
- replicate: 該次測量是第幾次重複
- y: 該次測量值








	
### Linearity_Study.png
- 一共有2個檔案，分別是"(1st\_vs\_2nd)Linearity_Study.png"與"(1st\_vs\_3rd)Linearity_Study.png"
- 依據在"Result\_of\_Regression_Analysis "中找出的最佳非線性，例如2nd，於是僅須觀看"(1st\_vs\_2nd)Linearity_Study.png"
- 同理，如果最佳非線性是3rd，則僅須觀看"(1st\_vs\_3rd)Linearity_Study.png"
- 圖中橫軸為相對濃度，縱軸為測量值，圖中除了測量值的點以外還有回歸線以不同顏色以及實線/虛線標示
- 從圖中可以比較出哪個多項式比較貼近測量值結果

### Difference_Plot.png
- 一共有2個檔案，分別是"(1st\_vs\_2nd)Difference_Plot.png"與"(1st\_vs\_3rd)Difference_Plot.png"
- 依據在"Result\_of\_Regression_Analysis "中找出的最佳非線性，例如2nd，於是僅須觀看"(1st\_vs\_2nd)Difference_Plot.png"
- 同理，如果最佳非線性是3rd，則僅須觀看"(1st\_vs\_3rd)Difference_Plot.png"
- 圖中橫軸為各測量值的平均值，縱軸為兩個多項式在該濃度的估計值的差值，圖中除了差值的點以外還有兩個虛線分別是允收的最大非線性%在該濃度的上下限 (在setting.csv中設置)
- 由於最大非線性%是根據橫軸的濃度值計算，因此濃度值越大其上下限值會越大(如果把縱軸改為%Difference則是恆定)

### Table
- 一共有2個檔案，分別是"(1st\_vs\_2nd)Table.csv"和"(1st\_vs\_3rd)Table.csv"
- 依據在"Result\_of\_Regression_Analysis "中找出的最佳非線性，例如2nd，於是僅須觀看"(1st\_vs\_2nd)Table.csv"
- 同理，如果最佳非線性是3rd，則僅須觀看"(1st\_vs\_3rd)Table.csv"
- 表格中各欄位說明如下:
	- Dilution: 相對濃度
	- y.Mean: 該濃度測量結果的平均
	- y.Diff: 該濃度測量結果間的差值
	- y.Squared_Diff: y.Diff平方
	- y.%Diff: 該濃度測量結果間的差值，以y.Mean的百分比呈現
	- y.Squared_%Diff: y.%Diff平方
	- Regression.1st: 該y.Mean以一次多項式回推的相對濃度值
	- Regression.2nd: 該y.Mean以二次多項式回推的相對濃度值
	- Regression.3rd: 該y.Mean以三次多項式回推的相對濃度值
	- Regression.Diff: 線性與非線性回推相對濃度值的差值
	- Regression.%Diff: 線性與非線性回推相對濃度值的差值，以y.Mean的百分比呈現
