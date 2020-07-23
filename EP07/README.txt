 1. In setting.csv, set the following parameters according your requirements:
    a. "EP7.Alpha" for the type-I error (e.g., 0.05 for 5%).
    b. "EP7.Beta" for the type-II error (e.g., 0.2 for 20%).
    c. "EP7.MP_rep" for the repeatability data (CV) from EP5 (e.g., 0.05 for 5%).
    d. "EP7.Allowable_interference" for the allowable interference (e.g., 0.05 for 5%). Results more than this degree will be considered as significant interference.

#For determination of replicate number
2. Open and run "ep7-Replicate_Number.R"
3. The result can be found as "Determine_Replicate_Number.txt" in analysis folder.

#For Paired Difference
4. Use "[Paired_Difference]_data.csv" as template and enter your own data, the first row (i.e., names of each parameters) should not be changed.
5. Save as data.csv and move to analysis folder.
6. Open and run "ep7-Paired_Difference.R".
7. The result can be found as "Paired_Difference_Report.txt" in analysis folder.
    
#For Dose Response
8. Use "[Dose_Response1]_data.csv" as template and enter your own data, the first row (i.e., names of each parameters) should not be changed.
9. Save as data.csv and move to analysis folder.
10. Open and run "ep7-Dose_Response.R".
11. The result can be found in analysis folder.

