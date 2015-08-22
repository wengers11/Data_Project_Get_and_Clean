# Data_Project_Get_and_Clean
The run_analysis script merges together the subject data, subject ids, the corresponding
activity ids and activities. It then subsets this data to just include columes that relate
to the mean and standard devation of the data. Next, it groups by subject and activity and 
computes the mean for each unique combination. Finally, it writes that tidy data set to 
a file called "tidy data summary.txt". 
