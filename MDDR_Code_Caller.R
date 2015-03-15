# LOAD UP OUR COMMON CODE and GET GLOBAL VARIABLES 
# LOAD THE FUNCTIONS FIRST!!!
source("DRCommon_Code.R")
source("DR_SQL_STRINGS.txt")
source("DR_SQL_STRINGS_BT.txt")
source("DR_RUNTIME_SETTINGS.txt")

# SEND INFO TO LOG FILE
print(REGRESSIONSTRING)

# DYNAMICALLY PULL THE DEPENDANT VARIABLE
DEP_VAR<-strsplit(REGRESSIONSTRING, "~")[[1]][1]
print(DEP_VAR)

# DETERMINE IF WE ARE A BACKTEST OR NOT (NEEDED FOR KOREA)
AREWEBACKTEST=0
if (substr(READDBID,1,3) == "PNY")
	AREWEBACKTEST=1

# GET DB CONNECTION (make sure you set up an ODBC data source on your PC)
CONNREAD <- odbcConnect(READDBID, uid = READDBUSER, pwd = READDBPWD, believeNRows=FALSE)

if (AREWEBACKTEST)
	CON_DATA<-getConsolidatedData()

# GET DATA PER COHORT PER PERIOD
PERS<-getPeriods()

#INPUT COHORT CODE
INPUTCOHORT  <- getInputCohorts()

#GET OUTPUT COHORTS
OUT_COHORT<-read.table("OutputCohorts.txt", header=TRUE, sep = "\t")

write(OUTPUTFILEHEADER,file=OUTPUTFILE, append=FALSE)

# Loop by period
for(i in 1:length(PERS))
{
	# Get the data for a period
	DATA <- getData(PERS[i])
	
	# New Cohorts
	DATA <- as.data.frame(merge(INPUTCOHORT, DATA, by=c("COUNTRY_ID")))

	# KOREA Addition
	if (AREWEBACKTEST && REGTYPE == "I")
		DATA <- performKoreaLogic(CON_DATA, DATA)
	  	
	#loop by cohort
	coh<-unique(DATA$DR_COHORT)
	for (i2 in 1:length(coh))
	{
		wData<-subset(DATA,DR_FILTER_FAIL_COUNT==0 & DR_COHORT==coh[i2])
		SUB_OUT<-subset(OUT_COHORT,DR_COHORT==coh[i2])
		# REGRESS
		if (nrow(wData) > 1 )
		# if more than one row we will regress -- after this we check to see if more than 10
		#  if more than 10 we regress normally, if not we take the average
		{
			if (nrow(wData) > 10 )
			{
				# HACK TO HANDLE SINGAPORE CROSS POP
				if( REGTYPE == "I" && coh[i2] == 2035 )
				{
					wData<-subset(DATA,(DR_COHORT==2035 | match(COMP_ID,SGP, nomatch = 0  ) > 0 ) & DR_FILTER_FAIL_COUNT==0)
				}
				mro <- lm(REGRESSIONSTRING,wData )
				tempReg<-coef(mro)
				MAINLEN<-length(tempReg)
				tempReg[is.na(tempReg)]<-0
				# HACK TO HANDLE >0 SIZE AND EUROPE processing for Financials
				if ( (REGTYPE == "F" && tempReg[2] > 0 ) || coh[i2] == 1013  || coh[i2] == 1014)
				{
					Intercept = rep(1,length(wData[[DEP_VAR]]))
					mro = lm(wData[[DEP_VAR]]~0+Intercept, wData)
					tempReg<-coef(mro)
					tempReg[is.na(tempReg)]<-0
					for (g in 2:MAINLEN) {
						tempReg[g]<-0
					}
				}			
				# WRITE OUT -- SET THE VARS
				REGVARS<-toString(tempReg)
				RSQ<-toString(summary(mro)$r.squared)
				TSTAT<-getPrintableTStats(mro)
				
			} else 
			{
				tempReg<-rep(0,SYSC_VARS)
				tempReg[1]<-mean(wData[[DEP_VAR]])
				# WRITE OUT -- SET THE VARS
				REGVARS<-toString(tempReg)
				RSQ<-""
				TSTAT<-""	
			}
			# WRITE OUT
			for (cc in unique(SUB_OUT$COUNTRY_ID)) 
			{
				write(paste(cc,PERS[i], REGVARS, toString(nrow(wData)), RSQ, TSTAT,sep=","),file=OUTPUTFILE, append=TRUE)	
			}
		} # END DO WE REGRESS (WAS NROWS > 1)
	}
# WRITE THE RECREATE FILE PER PERIOD
write.table(DATA,file=paste(DATAFILE,"_",PERS[i],".csv",sep=""), append=FALSE, row.names=FALSE, col.names=TRUE, sep=",") 
}

# CLEAN UP......
odbcCloseAll()	# CLOSE OUT DB CONNECTION
date()
