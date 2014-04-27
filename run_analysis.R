

#this functin load all necessary files
loadFile<-function(path=".\\UCI HAR Dataset"){
        ##load activity label
        activityLabel<<-read.table(file(paste(path,"activity_labels.txt",
                                             sep="\\")))
        ##load features
        features<<-read.table(file(paste(path,"features.txt",
                                         sep="\\")))
        ##load subject_train
        subject_train<<-read.table(file(paste(path,"train\\subject_train.txt",
                                              sep="\\")))
        ##load X_train
        ###set colclasses
        temp<-read.table(file(paste(path,"train\\X_train.txt",
                                    sep="\\")),nrows = 10)
        classes<-sapply(temp,class)
        ###actual load
        x_train<<-read.table(file(paste(path,"train\\X_train.txt",
                                        sep="\\")),colClasses=classes)
        ##load y_train
        y_train<<-read.table(file(paste(path,"train\\y_train.txt",
                                        sep="\\")))
        ##load subject_test
        subject_test<<-read.table(file(paste(path,"test\\subject_test.txt",
                                              sep="\\")))
        ##load X_test
        ###set colclasses
        temp<-read.table(file(paste(path,"test\\X_test.txt",
                                    sep="\\")),nrows = 10)
        classes<-sapply(temp,class)
        ###actual load
        x_test<<-read.table(file(paste(path,"test\\X_test.txt",
                                       sep="\\")))
        ##load y_test
        y_test<<-read.table(file(paste(path,"test\\y_test.txt",
                                       sep="\\")))
}

#this function merge train and test data in to one
dataMerge<-function(){
        ##merging x
        x_data<<-rbind(x_train,x_test)
        ##merging y
        y_data<<-rbind(y_train,y_test)        
        ##mergin subject
        subject_data<<-rbind(subject_train,subject_test)
        
}
#this function name the colume in the data with their 
#respecticve names in Feature.txt
nameCols<-function(){
        ##name each of the colume with their respecticve names in Feature.txt
        colnames(x_data)<<-features[,2]
        colnames(y_data)<<-"Activity"
        colnames(subject_data)<<-"Subject"
}

#this function extract mean and std from data
extraction<-function(){
        extractId<<-subset(features,
                           sapply(features$V2,grepl,pattern="-mean()",
                                  fixed=TRUE)|
                                   sapply(features$V2,grepl,pattern="-std()",
                                          fixed=TRUE))
        x_MS<<-x_data[,extractId$V1]
}

#this function name each row in the data with activity names
#identified in y_test.txt and y_train.txt
nameActivity<-function(){
        Activity<<-factor(y_data[,1],activityLabel[,1],labels=activityLabel[,2])
}
#this function takes means for each activities of each subject
takeMean<-function(){
         merged_data<<-cbind(subject_data,Activity)
         merged_data<<-cbind(merged_data,x_MS)
         melt_data<<-melt(merged_data,id=c("Subject","Activity"),
                          measure.var=names(x_MS))
         result_data<<-ftable(acast(melt_data,
                                    Subject ~ Activity ~ variable, 
                                    mean))        
        
}

#this function export the data in to your work place as Result.R
export<-function(){
        dput(result_data, file = "Result.txt")
}
#this is the main function
process<-function(path=".\\UCI HAR Dataset"){
        ##install the required package if not exits
        if(!"reshape2" %in% rownames(installed.packages())){
                install.packages("reshape2")
        }
        
        library(reshape2)
        
        print("Loading file, this may take several minutes")
        loadFile(path)
        print("Merging data")
        dataMerge()
        print("changing colume names")
        nameCols()
        print("extract required colume")
        extraction()
        print("name activities")
        nameActivity()
        print("take mean for subjects and activities")
        takeMean()
        print("exporting results")
        export()
        print("all done")
}