To use the script
1. put the original data folder(UCI HAR Dataset) in the same folder with run_analysis.R
2. double click run_analysis.R to open it in R studio
3. click source button to source the code
4. in console, type
```R
process()
```
and press enter
	
The results will be exported to result.txt
to reload results into R
use command:
```R
dget("result.txt")
```