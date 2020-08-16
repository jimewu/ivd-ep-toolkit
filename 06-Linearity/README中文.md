[英文版](README.md)
# 使用說明
## 複製範例檔案
1. 在"example"資料夾中可以找到"setting.csv"與"data.csv"，分別為程式執行參數以及實驗結果之範例檔案，將其複製到程式資料夾"06-Linearity"中
2. 程式實際執行時只會讀取程式資料夾"06-Linearity"中的檔案，example資料夾中的檔案僅供參考

## 設定參數
1. 編輯程式資料夾中的"setting.csv"，其內容如下:
	- EP6.Acceptance_Criteria: 表示設定之允收基準(i.e., 線性多項式與最佳非線性多項式的差異最大容許百分比)，預設值為5%(i.e., 0.05)，應依照實際需求進行修改
	- Max.N.Small: Report中計算結果表格檔案中的最大小數位數
	- FIG\_W\_CM: 報告的圖表寬度(單位為公分)
	- FIG\_H\_CM: 報告的圖表高度(單位為公分)
	- FIG\_DPI: 報告的圖表解析度(單位DPI)
2. 依照實際情況編輯後，存檔離開

## 填入資料
1. 編輯程式資料夾中的"data.csv"，其內容如下:
	- 每一列都是一筆結果，每一欄則是該筆資料的不同參數，因此若有80結果就應該有80列數值 (第一列為標題除外)
	- dilution: 該樣品的相對濃度作為簡易的標示，例如3個濃度的樣品分別濃度為1x, 2x, 3x,則分別標示為1, 2, 3
	- replicate: 表示該筆資料是第幾次重複
	- y: 該次的測量值
2. 現有之數值僅供示範參考，請刪除後依照格式填入自己的資料

## 執行程式
1. 執行"ep6-regression.R"

## 報告
1. 程式執行完成後，應該會產生報告資料夾，名稱類似於"Report-YYYY-MM-DD-hh-mm-ss"，其中包含的檔案在參見下方說明

### (QC)Sample\_Pooled\_Repeatability.txt
- 不同repeat之間的repeatability計算結果，須自行決定是否符合設定的標準

### Result\_of\_Regression_Analysis 
- 一共有3個檔案，分別是"(1st)Results_of_Regression_Analysis.txt", "(2nd)Results_of_Regression_Analysis.txt", "(3rd)Results_of_Regression_Analysis.txt"
- 分別代表將結果做一次多項式(1st), 二次多項式(2nd), 三次多項式(3rd)回歸的結果
- 每個檔案中的Coefficients裡面含有回歸的結果表格，各列說明如下:
	- (Intercept): 截距的結果，Estimate為估計值，Std. Error為標準差，Pr(>|t|) 為其顯著性(一般< 0.05表示顯著，即標注為*)
	- poly(dilution, 1, raw = TRUE): 一次多項式的斜率，各欄位說明與截距類似。
	- 其餘在二級/三級多項式回歸中以此類推，各欄位說明均類似。
	- 這個部份的重點在於確認一級多項式結果為顯著，並找出顯著的非線性多項式(2nd 或 3rd)
	
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
