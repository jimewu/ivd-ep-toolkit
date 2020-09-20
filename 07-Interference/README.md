[英文版](README.md)

# 1. 使用說明: 決定重複次數 (Replicate Number)

## 準備檔案

- 在"example1\_Replicate\_Number"資料夾找到所需要的setting.csv範例檔案，複製到程式資料夾"07-Interference"底下。
- 目前example資料夾中的檔案已經填入數值，可以用於執行相應程式並產生報告，但使用者應參考附錄"欄位說明"替換成自己的設定/數值。

## 執行程式 & 觀看報告

- 執行"ep07-1-Replicate_Number.R"
- 報告會出現在程式資料夾底下的"Report\_for\_Replicate\_Number_YYYY-MMDD-HHMMSS"資料夾下
-  依據報告結果:
	+ 不確定干擾影響結果方向(正向 or 負向均有可能)時，則應選擇for two-sided test所計算出的N值
	+ 確定干擾影響結果方向(正向 or 負向其中一個)時，則應選擇for one-sided test所計算出的N值

# 2. 使用說明: 配對差異分析 (Paired Difference)

## 準備檔案

- 在"example2\_Paired\_Difference"資料夾找到所需要的setting.csv以及data.csv範例檔案，複製到程式資料夾"07-Interference"底下。
- 目前example資料夾中的檔案已經填入數值，可以用於執行相應程式並產生報告，但使用者應參考附錄"欄位說明"替換成自己的設定/數值。

## 執行程式 & 觀看報告

- 執行"ep07-2-Paired_Difference.R"
- 報告會出現在程式資料夾底下的"Report\_for\_Paired\_Difference\_YYYY-MMDD-HHMMSS"資料夾下
- 可從報告中確認每個樣品之差異是否超過在setting.csv中設定之allowable difference，若超過則應進行後續分析。

# 3. 使用說明: 劑量分析 (Dose Response)

## 準備檔案

- 在"example3\_Dose\_Response"資料夾找到所需要的setting.csv以及data.csv範例檔案，複製到程式資料夾"07-Interference"底下。
- 目前example資料夾中的檔案已經填入數值，可以用於執行相應程式並產生報告，但使用者應參考附錄"欄位說明"替換成自己的設定/數值。

## 執行程式 & 觀看報告

- 執行"ep07-3-Dose_Response.R"
- 報告會出現在程式資料夾底下的"Report\_for\_Paired\_Difference\_YYYY-MMDD-HHMMSS"資料夾下
- "Dose\_Response\_Analysis\_Result.png": 測量值之線性回歸，虛線為setting.csv中設定之allowable interference之計算值
- Dose\_Response\_Analysis\_Result.txt: 詳細報告，依序包含干擾之方向，允許干擾程度下之最大干擾物濃度，以及線性回歸原始結果

# 附錄: 欄位說明

## setting.csv

說明: 各欄位應該依照使用者實際需求修改

- FIG\_W\_CM: 報告的圖表寬度(單位為公分)。
- FIG\_H\_CM: 報告的圖表高度(單位為公分)。
- FIG\_DPI: 報告的圖表解析度(單位DPI)。
- EP7.Alpha: type-I error，預設為0.05 (i.e., 5%)
- EP7.Beta: typ-II error，預設為0.2 (i.e., 20%)
- EP7.MP_rep: 量測方法的repeatability (參見ep5)，預設為0.05 (i.e., 5%)
- EP7.Allowable_interference: 允許之最大干擾程度，預設為0.05 (i.e., 5%)

## data.csv for (2)配對差異分析 (Paired Difference)

基本說明: 第一列是標題列，請勿更改。第二列起每一列是一筆資料，因此若有80筆結果就應該有80列。各欄位說明如下:

- Sample: 樣品為低濃度 (填入Low)或高濃度(填入High)
- Group: 該樣品沒有加入干擾物(控制組，填入control)或有加入干擾物(實驗組，填入test)
- Replicate: 該次測試為第幾次重複
- y: 測量值

## data.csv for (3) 劑量分析 (Dose Response)

基本說明: 第一列是標題列，請勿更改。第二列起每一列是一筆資料，因此若有80筆結果就應該有80列。各欄位說明如下:

- Sample: 該樣品的組別 (e.g., 第一組填入1)
- Replicate:  該次測試為第幾次重複
- Interference: 加入干擾物濃度 (無預設單位，同欄位所有量測應為同單位)
- y: 測量值