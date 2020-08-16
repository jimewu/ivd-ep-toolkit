[中文版](README中文.md)

# Instruction for Use
## Copy example files
1. Example files "setting.csv" and "data.csv" can be found at the "example" directory, copy them to here ("06-Linearity" directory).
2. The program/script would only read those two files under the "06-Linearity", and the examples files are for references only.

## Configure parameters
1. Edit the "setting.csv" file.  The meaning of each column is as the following:
	- EP6.Acceptance_Criteria: the acceptance criteria (i.e., the maximal allowable difference (%) of the linear and best non-linear regression). The default value is set to 5% (i.e., 0.05), which should be modified as your own need.
	- Max.N.Small: The maximal digits after the decimal point of the number in the report table files.
	- FIG\_W\_CM: The width (in CM) of the figure to be generated as part of the report
	- FIG\_H\_CM: The height (in CM) of the figure to be generated as part of the report
	- FIG\_DPI: The resolution (in DPI) of the figure to be generated as part of the report
2. Edit the values of each colum according to your need and save.

## Enter data
1. Edit the "data.csv" file. The meaning of each column is as the following:
	- Each row should contain only one result/data, and each column is a parameter of a data. So if there are 80 results, the data.csv file should have 80 rows of numbers (not including the first header row)
	- dilution: the relative concentration of each sample simply used as its label here.
		- e.g., say there are 3 samples with concentrations: 1x, 2x, and 3x, so their label here should be 1, 2, and 3
	- replicate: the replicate number of this result
	- y: The measurement value.
2. Current values in the "data.csv" file is for references only and should be replaced by your own data.

## Run program/script
1. Run the "ep6-regression.R"

## Report
1. After the result has been calculated by the program, a report folder containing results can be found with the name similar to "Report-YYYY-MM-DD-hh-mm-ss".
2. Files can be found in the report folder and their meaning are described below.

### (QC)Sample\_Pooled\_Repeatability.txt
- The result of repeatability (%). Users should determine if it is acceptable by yourself.

### Result\_of\_Regression_Analysis 
- There are 3 files, including "(1st)Results_of_Regression_Analysis.txt", "(2nd)Results_of_Regression_Analysis.txt", and "(3rd)Results_of_Regression_Analysis.txt"
- The above 3 files are the result of 1st, 2nd, and 3rd polynomial regression.
- In each file, the 'Coefficients' section contains the result of regression. The meaning of each row and column are as below:
	- (Intercept): The intercept. 'Estimate' is the estimate value, 'Std. Error' is the standard deviation, 'Pr(>|t|)' is its degree of significance (typically considered significant if < 0.05 and labeled as *)
	- poly(dilution, 1, raw = TRUE): the slope of 1st regression. 
	- similar meaning applys to the result of 2nd and 3rd regression.
	- In this part, the key things are to make sure the linear regression is significant, and to find out the most significant non-linear regression (2nd or 3rd).
	
### Linearity_Study.png
- There are 2 files, including "(1st\_vs\_2nd)Linearity_Study.png" and "(1st\_vs\_3rd)Linearity_Study.png"
- Following the most significant non-linear regression found in "Result\_of\_Regression_Analysis ", say 2nd for instance, you only need to examine  "(1st\_vs\_2nd)Linearity_Study.png".
- Similarly, if the most significant non-linear regression is 3rd regression, you only need to examine "(1st\_vs\_3rd)Linearity_Study.png".
- In this figure, the X-axis is the relative concentration, and the Y-axis is the measurement value. Besides the measurement values presented in this scatter plot, regression lines are presented in different colors and line-types (solid and dotted).
- In this figure, we can find out which regression line fits better the measurement values.

### Difference_Plot.png
- There are 2 files, including "(1st\_vs\_2nd)Difference_Plot.png" and "(1st\_vs\_3rd)Difference_Plot.png"
- Following the most significant non-linear regression found in "Result\_of\_Regression_Analysis ", say 2nd for instance, you only need to examine  "(1st\_vs\_2nd)Difference_Plot.png".
- Similarly, if the most significant non-linear regression is 3rd regression, you only need to examine "(1st\_vs\_3rd)Difference_Plot.png".
- In this figure, the X-axis is the average of the measurement value, and the Y-axis is the difference value of 2 regression equation (at that measurement value). Two dotted lines are the upper and lower limits of non-linearity (the allowable difference  value of linear and best non-linear, set as % in the setting.csv file)
- as the allowable difference  values are calculated as the (measurement value)*(allowable % of difference), those values would increase when the measurement value increases.
- Alternatively, if the Y-axis is changed into %Difference, the upper and lower limit lines would then be horizontal.

### Table
- There are 2 files, including "(1st\_vs\_2nd)Table.csv" and "(1st\_vs\_3rd)Table.csv"
- Following the most significant non-linear regression found in "Result\_of\_Regression_Analysis ", say 2nd for instance, you only need to examine  "(1st\_vs\_2nd)Table.csv"
- Similarly, if the most significant non-linear regression is 3rd regression, you only need to examine "(1st\_vs\_3rd)Table.csv"
- In this table, the meaning of each column is described as below:
	- Dilution: The relative concentration of each sample simply used as its label here.
	- y.Mean: The average of measurement values of that dilution
	- y.Diff: The difference of measurement values of that dilution
	- y.Squared_Diff: The square of y.Diff
	- y.%Diff: The difference of measurement values of that dilution, presented in the percentage of y.Mean.
	- y.Squared_%Diff: The square of y.%Diff
	- Regression.1st: The estimate value of that y.Mean calculated using 1st regression equation.
	- Regression.2nd: The estimate value of that y.Mean calculated using 2nd regression equation.
	- Regression.3rd: The estimate value of that y.Mean calculated using 3rd regression equation.
	- Regression.Diff: The difference of estimate values of that y.Mean calculated using linear and best non-linear regression equation.
	- Regression.%Diff: The difference of estimate values of that y.Mean calculated using linear and best non-linear regression equation, presented in the percentage of y.Mean.