This script builds support vector machine (SVM) classifier using the SVM package to predict the direction of change the exchange rate based on solely the historical rates. See "project_writeup.pdf" for more details and the results about the course project.  

File description:
EURUSD_**.csv: EUR/USD exchange rate from 1999/01/04 to 2010/11/04 with different time intervals. The training/test data for SVM.
trading.m: main script to parse the file, construct the features, perfrom cross-validation
ps2code: SVM package provided by MIT Machine Learning course (6.867)
