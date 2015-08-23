##libraries needed
library(dplyr)

##read in Files for Y activity data

y_test<-read.table("y_test.txt")           ##Contains the activity IDs for the test subjects
y_train<-read.table("y_train.txt")        ## Contains the activity IDs for the train subjects
act_lab<-read.table("activity_labels.txt")  ## Contains a table linking the activity IDs the Activity Name

names(act_lab)<-c("Activity_ID", "Activity_Name") ##Names columns in Activity_labels
names(y_test)<-"Activity_ID"                             ##Names column in y_test
names(y_train)<-"Activity_ID"                            ##Names column in y_train

y_test_join<-left_join(y_test,act_lab,by=c("Activity_ID"))  ##link the test subjects with their activity name
y_train_join<-left_join(y_train,act_lab,by=c("Activity_ID")) ##link the train subjects with their activity name

##bind the Y test/train sets together
y_all<-bind_rows(y_test_join,y_train_join)

## read in files for X subject data
x_test<-read.table("X_test.txt")
x_train<-read.table("X_train.txt")
subject_test<-read.table("subject_test.txt")
subject_train<-read.table("subject_train.txt")
feature_labels<-read.table("features.txt")      ##read in feature labels which are columns of X subject data

subject_all<-bind_rows(subject_test,subject_train)
names(subject_all)<-"Subject_ID"              ##Give label to subject column
x_all<-bind_rows(x_test,x_train)                
names(x_all)<-feature_labels$V2                ##add column labels to subject data

x_all<-bind_cols(subject_all,x_all)           ## bind subject IDs to subject outputs/data

##selects just the columns containing mean and std variables

##x_select<-x_all[,c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,
##                   240:241,253:254,266:271,294:296,345:350,373:375,
##                   424:429,452:454,503:504,516:517,529:530,542:543)]

##selects just the columns containing mean and std variables
## grepl looks for text that matches the input in the location specified (i.e. column names)
x_select<-x_all[,grepl("mean", names(x_all)) | grepl("std", names(x_all))]

my_data<-bind_cols(y_all,x_select)       ## combines the X and Y data pieces

my_data<-tbl_df(my_data)                 ##Converts to tbl_dt class

## Groups by Activity Name and Subject ID and then calculates the mean for each variable
Activity_summary<-my_data %>% group_by(Activity_Name,Subject_ID) %>% summarise_each(funs(mean)) %>%
                  arrange(Subject_ID,Activity_ID)
##writes the tidy data file
write.table(Activity_summary, file="tidy data summary.txt", row.name=FALSE)



