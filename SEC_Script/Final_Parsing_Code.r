## Required Libararies
library(edgarWebR)
library(readxl)
library(lubridate)


## Read the csv file with all listings
Edgar_10KQ <- read.csv('./Capstone/10KQ/EDGAR_10K_10Q.csv')
#Edgar_10KQ <- read.csv('C:\\Users\\mailt\\Documents\\Capstone\\10KQ\\EDGAR_10K_10Q.csv')


## Rename the column headers
colnames(Edgar_10KQ) <- c('S.No', 'CompanyID', 'CompanyName', 'TypeOfFiling', 'DateFiled', 'TextURL', 'HTMLURL')

## SEC main url
sec_URL = 'https://www.sec.gov/Archives/'

## Append the main url 
Edgar_10KQ <- transform(Edgar_10KQ, TextURL = paste0(sec_URL, TextURL))
Edgar_10KQ <- transform(Edgar_10KQ, HTMLURL = paste0(sec_URL, HTMLURL))

## Get the year and quarter details
for(i in 1:nrow(Edgar_10KQ)) {
  Edgar_10KQ$Year[i] <- substr(toString(Edgar_10KQ$DateFiled[i]), 1, 4)
  Edgar_10KQ$Quarter[i] <- quarter(toString(Edgar_10KQ$DateFiled[i]), with_year = FALSE)
}


## Split filings to 10-K and 10-Q
Edgar_10K <- Edgar_10KQ[which(Edgar_10KQ$TypeOfFiling == '10-K'),]
Edgar_10Q <- Edgar_10KQ[which(Edgar_10KQ$TypeOfFiling == '10-Q'),]


## Read the list of companies that need to be parsed
companyList <- read.csv('./Capstone/companyList.csv', header = TRUE, 
                        sep = ",", stringsAsFactors=FALSE)

## Assign column heading
colnames(companyList) <- c("CompanyName")  

## Collapse the list of companies as a single string to look against the url list
compList <- paste(companyList$CompanyName, collapse = "|")


## To get only the list of required companies with its url and other details
Edgar_10K_sublist <- Edgar_10K[grepl(compList, Edgar_10K$CompanyName, ignore.case = TRUE), ]
Edgar_10Q_sublist <- Edgar_10Q[grepl(compList, Edgar_10Q$CompanyName, ignore.case = TRUE), ]


## Create a matrix to store the parsed text companywise: 10-K
iter10K <- nrow(Edgar_10K_sublist)
columnNames10K <- c('CompanyName', 'TypeOfFiling', 'Year', 'Quarter', 'Item1', 'Item1A',
                    'Item7', 'Item7A', 'Item8', 'Item9', 'AccessedURL')
output10K <- matrix(ncol = length(columnNames10K), nrow = iter10K)



## Create a matrix to store the parsed text companywise: 10-Q
iter10Q <- nrow(Edgar_10Q_sublist)
columnNames10Q <- c('CompanyName', 'TypeOfFiling', 'Year', 'Quarter', 'FSS', 'RiskFactors',
                    'MDA', 'MarketRisk', 'LegalProceedings', 'ControlProcedures', 
                    'AccessedURL')
output10Q <- matrix(ncol = length(columnNames10Q), nrow = iter10Q)



## Function that extracts content itemwise for 10-K

parse10Kfilings <- function(output10K, columnNames) {
  for (i in 1:iter10K) {
    docs <- filing_documents(Edgar_10K_sublist$HTMLURL[i])
    doc <- docs[docs$description == 'Complete submission text file', ]
    parsed_docs <- parse_submission(doc$href)
    filing_doc <- parsed_docs[parsed_docs$TYPE == '10-K', 'TEXT']
    doc <- parse_filing(filing_doc, include.raw = TRUE)
    
    business <- paste(unlist(doc[grepl("business", doc$item.name, ignore.case = TRUE), "text"]), collapse = " ")
    riskFactors <- paste(unlist(doc[grepl("risk factors", doc$item.name, ignore.case = TRUE), "text"]), collapse = " ")
    MDA <- paste(unlist(doc[grepl("discussion and analysis", doc$item.name, ignore.case = TRUE), "text"]), collapse = " ")
    marketrisk <- paste(unlist(doc[grepl("market risk", doc$item.name, ignore.case = TRUE), "text"]), collapse = " ")
    finance <- paste(unlist(doc[grepl("financial statements", doc$item.name, ignore.case = TRUE), "text"]), collapse = " ")
    ctrlProc <- paste(unlist(doc[grepl("controls and procedures", doc$item.name, ignore.case = TRUE), "text"]), collapse = " ")
    output10K[i, ] <- c(toString(Edgar_10K_sublist$CompanyName[i]), '10-K', Edgar_10K_sublist$Year[i], 
                        Edgar_10K_sublist$Quarter[i], business, riskFactors, MDA, 
                        marketrisk, finance, ctrlProc, Edgar_10K_sublist$HTMLURL[i])
  }
  myparsedDF <- data.frame(output10K)
  colnames(myparsedDF) <- columnNames
  myparsedDF
}


#Function that extracts content itemwise for 10-Q
parse10Qfilings <- function(output10Q, columnNames) {
  for (i in 1:iter10Q) {
    docs <- filing_documents(Edgar_10Q_sublist$HTMLURL[i])
    doc <- docs[docs$description == 'Complete submission text file', ]
    parsed_docs <- parse_submission(doc$href)
    filing_doc <- parsed_docs[parsed_docs$TYPE == '10-Q', 'TEXT']
    doc <- parse_filing(filing_doc, include.raw = TRUE)
    
    FSS <- paste(unlist(doc[grepl("financial statements", doc$item.name, ignore.case = TRUE), "text"]), collapse = " ")
    riskFactors <- paste(unlist(doc[grepl("risk factors", doc$item.name, ignore.case = TRUE), "text"]), collapse = " ")
    MDA <- paste(unlist(doc[grepl("discussion and analysis", doc$item.name, ignore.case = TRUE), "text"]), collapse = " ")
    marketRisk <- paste(unlist(doc[grepl("market risk", doc$item.name, ignore.case = TRUE), "text"]), collapse = " ")
    legalProc <- paste(unlist(doc[grepl("legal proceedings", doc$item.name, ignore.case = TRUE), "text"]), collapse = " ")
    ctrlProc <- paste(unlist(doc[grepl("controls and procedures", doc$item.name, ignore.case = TRUE), "text"]), collapse = " ")
    
    
    output10Q[i, ] <- c(toString(Edgar_10Q_sublist$CompanyName[i]), '10-Q', Edgar_10Q_sublist$Year[i],
                        Edgar_10Q_sublist$Quarter[i], FSS, riskFactors, MDA, marketRisk, 
                        legalProc, ctrlProc, Edgar_10Q_sublist$HTMLURL[i])
  }
  myparsedDF <- data.frame(output10Q)
  colnames(myparsedDF) <- columnNames
  myparsedDF
}


## Function call and save the parsed content to a dataframe: 10K
parsedDF10KFinal <- parse10Kfilings(output10K, columnNames10K)

## Function call and save the parsed content to a dataframe: 10Q
parsedDF10QFinal <- parse10Qfilings(output10Q, columnNames10Q)


## Write the dataframes as csv files
write.csv(parsedDF10KFinal, "./Capstone/ParsedText/parsedText10K.csv", row.names = FALSE)
write.csv(parsedDF10QFinal, "./Capstone/ParsedText/parsedText10Q.csv", row.names = FALSE)
