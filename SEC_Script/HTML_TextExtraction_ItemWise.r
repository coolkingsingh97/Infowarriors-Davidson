library(kableExtra) 
library(edgarWebR)
library(readxl)
library(lubridate)

setwd("/Users/bhumikakhandelwal/Documents/Documents/Documents/Academics/Capstone/ProjectWork/Capstone_NLP_DIWD/SEC_Output_Files")
## Read the csv file with all listings
Edgar_10KQ <- read.csv('./EDGAR_10K_10Q.csv')


## Rename the column headers
colnames(Edgar_10KQ) <- c('S.No', 'CompanyID', 'CompanyName', 'TypeOfFiling', 'DateFiled', 'TextURL', 'HTMLURL')
sec_URL = 'https://www.sec.gov/Archives/'

## Append the main url 
Edgar_10KQ <- transform(Edgar_10KQ, TextURL = paste0(sec_URL, TextURL))
Edgar_10KQ <- transform(Edgar_10KQ, HTMLURL = paste0(sec_URL, HTMLURL))

##Get the year and quarter details
Edgar_10KQ$Year <- substr(toString(Edgar_10KQ$DateFiled), 1, 4)
Edgar_10KQ$Quarter <- quarter(as.character(Edgar_10KQ$DateFiled), with_year = FALSE)

##Split filings to 10-K and 10-Q
Edgar_10K <- Edgar_10KQ[which(Edgar_10KQ$TypeOfFiling == '10-K'),]
Edgar_10Q <- Edgar_10KQ[which(Edgar_10KQ$TypeOfFiling == '10-Q'),]


#For development purpose
a <- head(Edgar_10K,5000)
Edgar_10K <- a

b <- head(Edgar_10Q,5000)
Edgar_10Q <- b


##Code sourced from: https://cran.r-project.org/web/packages/edgarWebR/vignettes/parsing.html
#Create a matrix to store the parsed text companywise: 10-K
iter <- nrow(Edgar_10K)
columnNames10K <- c('CompanyName', 'TypeOfFiling', 'Year', 'Quarter', 'Item1', 'Item1A',
                 'Item7', 'Item7A', 'Item8', 'Item9', 'AccessedURL')
output10K <- matrix(ncol = length(columnNames10K), nrow = iter)


#Function that extracts content itemwise for 10-K
parse10Kfilings <- function(output10K, columnNames) {
    for (i in 1:iter) {
        docs <- filing_documents(Edgar_10K$HTMLURL[i])
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
        output10K[i, ] <- c(toString(Edgar_10K$CompanyName[i]), '10-K', Edgar_10K$Year[i], 
                            Edgar_10K$Quarter[i], business, riskFactors, MDA, 
                            marketrisk, finance, ctrlProc, Edgar_10K$HTMLURL[i])
  }
  myparsedDF <- data.frame(output10K)
  colnames(myparsedDF) <- columnNames
  myparsedDF
}

parsedDF10K <- parse10Kfilings(output10K, columnNames10K)


###############################################################################
#Create a matrix to store the parsed text companywise: 10-Q
iter <- nrow(Edgar_10Q)
columnNames10Q <- c('CompanyName', 'TypeOfFiling', 'Year', 'Quarter', 'FSS', 'RiskFactors',
                    'MDA', 'MarketRisk', 'LegalProceedings', 'ControlProcedures', 
                    'AccessedURL')
output10Q <- matrix(ncol = length(columnNames10Q), nrow = iter)


#Function that extracts content itemwise for 10-Q
parse10Qfilings <- function(output10Q, columnNames) {
  for (i in 1:iter) {
    docs <- filing_documents(Edgar_10Q$HTMLURL[i])
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

    
    output10Q[i, ] <- c(toString(Edgar_10Q$CompanyName[i]), '10-Q', Edgar_10Q$Year[i],
                        Edgar_10Q$Quarter[i], FSS, riskFactors, MDA, marketRisk, 
                        legalProc, ctrlProc, Edgar_10Q$HTMLURL[i])
  }
  myparsedDF <- data.frame(output10Q)
  colnames(myparsedDF) <- columnNames
  myparsedDF
}

parsedDF10Q <- parse10Qfilings(output10Q, columnNames10Q)



## Write the dataframes as csv files
write.csv(parsedDF10K, "./parsed_files/parsedText10K.csv", row.names = FALSE)
write.csv(parsedDF10Q, "./parsed_files/parsedText10Q.csv", row.names = FALSE)







