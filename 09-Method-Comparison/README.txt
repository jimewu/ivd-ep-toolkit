1. In setting.csv, set the following parameters according your requirements:
    a. "EP9.Error_Ratio" for the ratio between squared measurement errors of comparative and testing method, only needed for Deming regression (e.g., default is 1).
    b. "EP9.alpha" for the type-I error (e.g., 0.05 for 5%).

#For outlier detection by Extreme Studentized Deviate
2. Use data.csv as template and enter your own data, the first row (i.e., names of each parameters) should not be changed.
3. Save as data.csv and move to analysis folder.
4. Open and run "Outlier_detection.R".
5. The result can be found as "Outlier_Result.txt" in analysis folder.
6. The thus suggested outlier is not automatically removed, you have to determine and do it manually by removing data from data.csv and save.

#For Method Comparison
7. Open and run "Method_Comparison.R".
8. The results can be found in the analysis folder.
9. All possible models are calculated, but the suitable one should be determined by your own.
