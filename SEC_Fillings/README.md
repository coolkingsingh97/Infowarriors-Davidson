# This folder contains all the code, intermediate and final output data files related to SEC Filings

## The content of each folder is mentioned below:

**index_files:** It contains the list of .tsv files that are downloaded from the SEC.gov website using EDGAR library. These are the initial files that gets downloaded and it has the list of companies with its corresponding urls to download the 10-K and 10-Q filings. These files are named based on the year and quarter that it belongs to.

**10KQ_files:** The list of 10K and 10-Q filings are filtered out of the .tsv files and saved in this folder. EDGAR_10K: list of 10-K filings, EDGAR_10Q: list of 10-Q filings, EDGAR_10K_10Q: list of both 10-K and 10-Q filings.

**parsed_files:** This folder contains separate csv files for both 10-K and 10-Q with section wise parsed text from SEC filings. 

**final_output_files:** The data after text pre-processing with no of positive words, no of negative words, gunning fog index saved as .csv files is available in this folder.

**codebase:** It consists of all the code required to download, parse and process the data. The description of each file is mentioned and listed in the order of execution.

	Download_IndexFiles: Needs to be executed first to download the .tsv files to the 'index_files' folder and save the filtered 10-K/10-Q listings to the '10KQ_files' folder. 
	SECItemwise_Parsing_Code: Reads data from the '10KQ_files' folder, parses the data and saves the output file in the folder 'parsed_files'
	Text-Preprocessing_10K: Pre-processes the text and computes the metrics for 10-K files. Reads data from 'parsed_files' folder and save the output to 'final_output_files' folder. 
	Text-Preprocessing_10Q: Pre-processes the text and computes the metrics for 10-Q files. Reads data from 'parsed_files' folder and save the output to 'final_output_files' folder. 

**dictionaries:** contains the list of stopwords, positive and negative words.




