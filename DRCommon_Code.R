# R scripts
# We'll jam requires in here as well....
require(RODBC)
require(MASS)
require(car)

# VARIOUS FUNCTIONS....

getDataCurrent <- function (PERIOD)
{
  sqlQuery(CONNREAD, CSSQLSTRING  )
}

getDataBacktest <- function (PERIOD)
{
  sqlQuery(CONNREAD, paste(BTSQLSELECT," FROM ",BACKTEST_TABLE,BTSQLWHERE,PERIOD,sep="") )
}

# Get the number of periods to iterate over
getPeriods <- function ()
{
  d1<-as.Date(paste(LATESTPERIOD,"01",sep=""),"%Y%m%d")
  d2<-as.Date(paste(EARLIESTPERIOD,"01",sep=""),"%Y%m%d")
  d3<-seq.Date(d2,d1,"month")
  d4<-format(d3,"%Y%m")
}

SGP<-c(53800004,53800020,53800003,53800368,53802047,53800073,549900084,53800066,53801914,53800135,53800008,875400063,875400106,53800185,53800036,53800486,53800482,53800611,1033300007,87540086,53800051,53800171,1033300008,53800458,53800063,53800058,1302600046,1302600053,1302600208,1302600553)

getIndustrialsInputCohorts<- function ()
{
  read.table("INDUSTRIALS_MDDRINPUT_COHORTS.txt", header=TRUE, sep = "\t")
}

getFinancialsInputCohorts<- function ()
{
  read.table("FINANCIALS_MDDRINPUT_COHORTS.txt", header=TRUE, sep = "\t")
}

getConsolidatedData<- function ()
{
	sqlQuery(CONNREAD, "SELECT company_id AS COMP_ID, status_cd AS PRODUCT_CD, consolidated_company_id AS CONSOLIDATED_ID FROM d_company WHERE country_id = 7141 AND consolidated_company_id > 0")
}

performKoreaLogic <- function (CON_DATA, DATAx1)
{
	# Merge data == all.y makes sure data is padded, as this is the main data frame -- 
	DATA <- as.data.frame(merge(CON_DATA, DATAx1, by=c("COMP_ID"), all.y = TRUE))
	
	# get a list of consolidated ids
	# format  "COMP_ID"         "PRODUCT_CD"      "CONSOLIDATED_ID"
	CON_IDS<-subset(DATA,CONSOLIDATED_ID > 0, select = CONSOLIDATED_ID)
	
	# create a data frame of consolidated company ids and their fail counts from the main merged data frame
	# format is "COMP_ID"              "DR_FILTER_FAIL_COUNT"
	copyDATA <- subset(DATA,COMP_ID %in% CON_IDS$CONSOLIDATED_ID, select = c(COMP_ID,DR_FILTER_FAIL_COUNT))
	
	# rename the copydata column names --  the compid is the consolidated id, the con filter fail count needs a distinct name
	names(copyDATA)[1] = "CONSOLIDATED_ID" ; names(copyDATA)[2] = "CON_DR_FILTER_FAIL_COUNT"
	
	# merge the "DATA" data frame with the consolidated data frame
	# keeping all "DATA" data frame rows
	# what we have now is a roughly regular row, and if exists the consolidated id and fail count in the same row	
	DATA_MERGE <- merge(DATA, copyDATA, by=c("CONSOLIDATED_ID"), all.x = TRUE)
	
	# Now, check inproduct companies
	# If they have a consolidated company that passes the dr filter -- then fail the inproduct company..
	# Give a 1234 code for this
	DATA_MERGE$DR_FILTER_FAIL_COUNT[DATA_MERGE$PRODUCT_CD == "I" & DATA_MERGE$DR_FILTER_FAIL_COUNT == 0 & DATA_MERGE$CON_DR_FILTER_FAIL_COUNT == 0] <- 1234
	
	# R needs an assignment to return from a function....
	RTNDATA<-DATA_MERGE
}

getPrintableTStats <- function(mro)
{
	XXX<-toString(summary(mro)$coef[,3])
	temp_split<-strsplit(XXX,",")
	if (length(summary(mro)$aliased) != length(strsplit(XXX,",")[[1]]) )
	{
		cnt<-1
		vv<-summary(mro)$aliased
		out_str<-""
		for (xx in 1:length(vv))
		{
			if(vv[[xx]] == "FALSE")
			{
				if(out_str=="") {
					out_str<-temp_split[[1]][cnt]
				} else {
					out_str<-paste(out_str,temp_split[[1]][cnt],sep=",")
			}
			cnt<-cnt+1
			} else {
				out_str<-paste(out_str," 0",sep=",")
			}
	}
	XXX<-out_str
	} else {
		XXX<-toString(summary(mro)$coef[,3])
	}
}

getVIFStats <- function(mro)
{
	XXX<-toString(vif(mro))
}
