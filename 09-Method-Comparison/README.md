[英文版](README.md)

# 使用說明

## 準備檔案

- 在example資料夾找到所需要的setting.csv以及data.csv範例檔案，複製到程式資料夾"09-Method-Comparison"底下。
- 目前example資料夾中的檔案已經填入數值，可以用於執行相應程式並產生報告，但使用者應參考附錄"欄位說明"替換成自己的設定/數值。

## 執行程式 & 觀看報告

### 1. 找出outliers

- 執行"ep09-1-Outlier_detection.R"
- 報告會出現在程式資料夾底下的"Report\_for\_Outlier\_Detection_YYYY-MMDD-HHMMSS"資料夾下
- 可依據結果所建議的outlier(s) (Outlier欄位為TRUE)，將其從data.csv中刪除，然在再繼續執行後續程式。

### 2. Method Comparison

- 執行"ep09-2-Method_Comparison.R"
- 報告會出現在程式資料夾底下的"Report\_for\_Method\_Comparison_YYYY-MMDD-HHMMSS"資料夾下
- 由於報告檔案較多，請參閱附錄"Method Comparison報告說明"

# 附錄: 欄位說明

## setting.csv

說明: 各欄位應該依照使用者實際需求修改

- FIG\_W\_CM: 報告的圖表寬度(單位為公分)。
- FIG\_H\_CM: 報告的圖表高度(單位為公分)。
- FIG\_DPI: 報告的圖表解析度(單位DPI)。
- EP9.Error_Ratio: 
	- 如果data.csv中填入的每筆數值為單次結果 (不是多次平均)，則此欄為維持不變為1即可。
	- 如果data.csv中填入的每筆數值不是單次結果而是多次重複的平均，則本欄位應該填入"待測方法的precision除以參考方法的precision的比值"。
- EP9.alpha: type-I error，預設為0.05 (i.e., 5%)

## data.csv

基本說明: 第一列是標題列，請勿更改。第二列起每一列是一筆資料，因此若有80筆結果就應該有80列。各欄位說明如下:

- MP.comp: 對比方法(i.e., 參考方法)的測量值
- MP.test：待測方法的測量值

# 附錄: Method Comparison報告說明

以下依照閱讀檔案的順序說明:

- Scatter\_Plot.png: 原始結果的scatter plot
	+ X: 對比方法(i.e., 參考方法)
	+ Y: 待測方法
- Difference_Plot系列:
	+ X軸均為對比方法(i.e., 參考方法)，Y軸說明如下:
		+ Difference\_Plot\_Marginal\_Histogram.png: (待測方法-對比方法)，並在右側以histogram顯示數量
		+ Difference\_Plot\_Marginal.png: (待測方法-對比方法)，並在右側以輪廓顯示數量
		+ Percent\_Difference\_Plot\_Marginal\_Histogram.png: 100 *  (待測方法-對比方法) / (對比方法)，並在右側以histogram顯示數量
		+ Percent_Difference_Plot_Marginal.png: 100 *  (待測方法-對比方法) / (對比方法)，並在右側以輪廓顯示數量
- Summary\_of\_All\_Regression.pdf: 使用不同方法進行線性回歸，理想值為最接近紅色虛線者。
- 其他檔案: 依照Summary_of_All\_Regression.pdf的結果，選擇最佳回歸方式，例如Deming Regression，則可在(Deming)Regression\_Plot.pdf找到回歸圖，在(Deming)Regression\_Summary.txt找到回歸的計算結果，在(Deming)Bias\_Plot.pdf找到Bias的圖。其餘檔案則不須使用。