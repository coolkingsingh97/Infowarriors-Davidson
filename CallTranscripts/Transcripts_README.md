# Call Transcripts: Download, Preprocessing and Analysis

## This folder contains the codebase, intermediate and final output data files associated with the Call Transcripts downloaded from SeekingAlpha

### The content of each folder is mentioned below:

**Codebase:** It consists of all the code required to download, parse and process the data. The description of each file is mentioned and listed in the order of execution.

- Download_IndexFiles: Needs to be executed first to download the .tsv files to the 'index_files' folder and save the filtered 10-K/10-Q listings to the '10KQ_files' folder. 
- SECItemwise_Parsing_Code: Reads data from the '10KQ_files' folder, parses the data and saves the output file in the folder 'parsed_files'
- Text-Preprocessing_10K: Pre-processes the text and computes the metrics for 10-K files. Reads data from 'parsed_files' folder and save the output to 'final_output_files' folder. 
- Text-Preprocessing_10Q: Pre-processes the text and computes the metrics for 10-Q files. Reads data from 'parsed_files' folder and save the output to 'final_output_files' folder. 
	

**Call_Transcripts_Seeking_Alpha** :
This folder contains transcript of every company in the download list, organized by year and quarter. The files have a nomenclature system that contains the company name, year and quarter which the call transcript represents. For example, the Q1 2019 call transcript text file for Google is named as follows: ***CT_GOOG_2019_q1***.  

**outputs:** This folder contains the intermediate and final excel outputs from the preprocessing and analysis phases. The details of each file are described below:

- CallTranscripts_DataFrame_1:   
Column Names:
```
	CallTranscriptID	PublishedTime	Quarter	Ticker	Year	summary	title

```


- CallTranscripts_DataFrame_2:  
Column Names:
```
		CallTranscriptID	PublishedTime	Quarter	Ticker	Year	summary	title	total_words	pos_word_count	neg_word_count	pos_words	neg_words	GunningFogIndex	pos_words_unique	pos_words_count	neg_words_unique	neg_words_count	pos_word_cloud	neg_word_cloud

```
	
- CallTranscripts_DataFrame_Analyst_Exec_Breakup:   
Column Names:
```
	Speaker	TalkTrack	Org_Title	SpeakerType	CallTranscriptID	Ticker	Year	Quarter	GunningFogIndex	total_words	pos_word_count	neg_word_count	pos_words	neg_words

```
	
- CallTranscripts_DataFrame_Sentiments:   
Column Names:
```
	CallTranscriptID	PublishedTime	Quarter	Ticker	Year	summary	title	total_words	pos_word_count	neg_word_count	pos_words	neg_words	GunningFogIndex	pos_words_unique	pos_words_count	neg_words_unique	neg_words_count	pos_word_cloud	neg_word_cloud	ID	TICKER_AND_EXCH_CODE	TICKER	NAME	COMPANY_WEB_ADDRESS	CITY_OF_DOMICILE	STATE_OF_DOMICILE	CNTRY_OF_DOMICILE	GICS_SECTOR_NAME	GICS_SUB_INDUSTRY_NAME	GICS_INDUSTRY_NAME	GICS_INDUSTRY_GROUP_NAME	ID_CUSIP	CENTRAL_INDEX_KEY_NUMBER	FED TAX ID NUMBER	ID ISIN	ID SEDOL1	ID COMMON
```



