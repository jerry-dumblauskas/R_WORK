# LOAD UP OUR COMMON CODE and GET GLOBAL VARIABLES
# LOAD THE FUNCTIONS FIRST!!!
source("DRCommon_Code.R")
source("DR_SQL_STRINGS.txt")
source("DR_SQL_STRINGS_BT.txt")
source("DR_RUNTIME_SETTINGS.txt")

# GET DB CONNECTION (make sure you set up an ODBC data source on your PC)
CONNREAD <- odbcConnect(READDBID, uid = READDBUSER, pwd = READDBPWD, believeNRows=FALSE)
PERS<-getPeriods()

#create file
date()
write(OUTPUTFILEHEADER,file=OUTPUTFILE, append=FALSE)
# Loop by period
for(i in 1:length(PERS))
{
	# Get the data for a period
	DATA <- getData(PERS[i])
	# REGRESS
	if (nrow(DATA) > 2 )
	{
		mro <- lm(REGRESSIONSTRING,DATA)
		tempReg<-coef(mro)
		tempReg[is.na(tempReg)]<-0
		# WRITE OUT
		write(paste(PERS[i], toString(tempReg),sep=","),file=OUTPUTFILE, append=TRUE)	
	}
# WRITE THE RECREATE FILE PER PERIOD
write.table(DATA,file=paste(DATAFILE,"_",PERS[i],".csv",sep=""), append=FALSE, row.names=FALSE, col.names=TRUE, sep=",")
}

# CLEAN UP......
odbcCloseAll()	# CLOSE OUT DB CONNECTION
date()
