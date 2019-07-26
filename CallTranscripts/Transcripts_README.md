# Call Transcripts: Download, Preprocessing and Analysis

## This folder contains the codebase, intermediate and final output data files associated with the Call Transcripts downloaded from SeekingAlpha

### The content of each folder is mentioned below:

**Codebase:** It consists of all the code required to download, parse and process the data. The description of each file is mentioned and listed in the order of execution.

- 1_CallTranscripts_DataFrame.ipynb : This notebook creates a data frame with a CallTranscriptID, and all the contents of the transcript in a column, and saves it to an excel file. 

- 2_CreateSentimentDataFrame_CallTranscripts.ipynb : This notebook does the bulk of the text preprocessing: namely, stemming, lemmatization, calculation of positive and negative words, calculation of positive and negative indexes and computation of the Gunning Fogg Index and creates an intermediate data frame with the positive and negative word counts, and positive and negative indexes for the entire transcript. The output is an excel that combines the computed metrics with the S&P excel fields, so they can all be imported into Tableau for data visualization.

- 3_SaveTranscriptsFromSeekingAlpha.ipynb: The code in this notebook retrieves the call transcripts from the SeekingAlpha website and saves it to text files, that are all saved in the Call_Transcripts_Seeking_Alpha folder. The filename has a format as follows - *CT_companyName_year_quarter*  

- 4_CallTranscripts_Preprocessing.ipynb: This notebook does the bulk of the text preprocessing: namely, stemming, lemmatization, calculation of positive and negative words, calculation of positive and negative indexes and computation of the Gunning Fogg Index, BUT does it post an Analyst and Executive breakdown of the transcript. The output is an excel that combines the computed metrics with the S&P excel fields, so they can all be imported into Tableau for data visualization.

- SentimentAnalysis_CallTranscripts.ipynb:
	

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



