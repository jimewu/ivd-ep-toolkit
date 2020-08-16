[中文版](README中文.md)

# Instruction for Use
## Copy example files
1. Example files "setting.csv" and "data.csv" can be found at the "example" directory, copy them to here ("05-Precision" directory).
2. The program/script would only read those two files under the "05-Precision", and the examples files are for references only.

## Configure parameters
1. Edit the "setting.csv" file. The meaning of each column is as the following:
	- EP5.Acceptance_Criteria: The acceptance criteria (%CV)，the default value is set to 5%(i.e., 0.05)，which should be modified as your own need.
	- FIG\_W\_CM: The width (in CM) of the figure to be generated as part of the report
	- FIG\_H\_CM: The height (in CM) of the figure to be generated as part of the report
	- FIG\_DPI: The resolution (in DPI) of the figure to be generated as part of the report
2. Edit the values of each colum according to your need and save.

## Enter data
1. Edit the "data.csv" file. The meaning of each column is as the following:
	- Each row should contain only one result/data, and each column is a parameter of a data. So if there are 80 results, the data.csv file should have 80 rows of numbers (not including the first header row)
	- Var1: The 1st parameter of your experimental design. For instance, in the 20 Days * 2 Runs * 2 Replicates, Var1 means Day.
	- Var2: The 2nd parameter of your experimental design. For instance, in the 20 Days * 2 Runs * 2 Replicates, Var2 means Run.
	- Rep: The 3rd parameter of your experimental design (i.e., replicate).
		- y: The measurement value.
2. Current values in the "data.csv" file is for references only and should be replaced by your own data.

## Run program/script
1. Run the "ep05-analysis.R"

## Report
1. After the result has been calculated by the program, a report folder containing results can be found with the name similar to "Report-YYYY-MM-DD-hh-mm-ss".
2. Files can be found in the report folder and their meaning:
	- Measurement_Results.png: Scatter plot of the original data. The X-axis is Var1, and the Y-axis is the measurement value (y). Each dot is further grouped into different colors and shapes according to its respective Var2 and Replicate.
	- Levey-Jennings.png: Almost the same as Measurement_Results.png, with only one difference that the Y-axis is the standard deviation (SD) which is convenient to find outliers.
	- Report.txt:
		- Summary: the brief description that whether a parameter (Total, Var1, Var2, and Replicate) is within the acceptance criteria (the percentage number set in the setting.csv)
		- Result of ANOVA: the result of nested-ANOVA
		- Confidence interval in SD: the confidence interval of total and replicate (error) parameter in SD
		- Confidence interval in %CV: the confidence interval of total and replicate (error) parameter in %CV