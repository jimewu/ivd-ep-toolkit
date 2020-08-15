[英文版](README.md)
# 使用說明
## 複製範例檔案
1. 在"example"資料夾中可以找到"setting.csv"與"data.csv"，分別為程式執行參數以及實驗結果之範例檔案，將其複製到程式資料夾"05-Precision"中
2. 程式實際執行時只會讀取程式資料夾"05-Precision"中的檔案，example資料夾中的檔案僅供參考

## 設定參數
1. 編輯程式資料夾中的"setting.csv"，其內容如下:
	- EP5.Acceptance_Criteria: 表示設定之允收基準(%CV)，預設值為5%(i.e., 0.05)，應依照實際需求進行修改
	- FIG\_W\_CM: 報告的圖表寬度(單位為公分)
	- FIG\_H\_CM: 報告的圖表高度(單位為公分)
	- FIG\_DPI: 報告的圖表解析度(單位DPI)
2. 依照實際情況編輯後，存檔離開

## 填入資料
1. 編輯程式資料夾中的"data.csv"，其內容如下:
	- 每一列都是一筆結果，每一欄則是該筆資料的不同參數，因此若有80結果就應該有80列數值 (第一列為標題除外)
	- Var1: 試驗設計中的1st參數，例如在20 Days * 2 Runs * 2 Replicates中，Var1就代表Day
	- Var2:試驗設計中的2nd參數，例如在20 Days * 2 Runs * 2 Replicates中，Var2就代表Run
	- Rep: 試驗設計中的3rd參數，也就是第幾個重複(replicate)
	- y: 該次的測量值
2. 現有之數值僅供示範參考，請刪除後依照格式填入自己的資料

## 執行程式
1. 執行"ep05-analysis.R"

## 報告
1. 程式執行完成後，應該會產生報告資料夾，名稱類似於"Report-YYYY-MM-DD-hh-mm-ss"