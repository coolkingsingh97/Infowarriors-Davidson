## Import required packages
## Install the packages first if required
import edgar
import pandas as pd
import requests
import re
import matplotlib.pyplot as plt


## Download the index file that consists list of companies with url to download the filings for a given year to the index_files folder
## Downloaded in tsv format
edgar.download_index("./index_files/", 2018)


## Convert the tsv to a dataframe
edgar_directories = pd.read_csv('./index_files/2018-QTR1.tsv', sep='|', header=None)

## Select only the 10K and 10Q filings 
edgar_10q_10k = edgar_directories[(edgar_directories[2] =='10-Q') | (edgar_directories[2]=='10-K')]


## Write the filtered filings list to a csv file for future use
edgar_10q_10k.to_csv('EDGAR_10K_10Q.csv')

## Read the csv file to a dataframe
Edgar_10K_DF = pd.read_csv('./index_files/EDGAR_10K_10Q.csv')

## Rename the column headers
Edgar_10K_DF.columns = ['S.No', 'CompanyID', 'CompanyName', 'TypeOfFiling', 'DateFiled', 'TextURL', 'HTMLURL']

## Parent url to access the filings
sec_URL = 'https://www.sec.gov/Archives/'

## Append the parent url 
Edgar_10K_DF['TextURL'] = sec_URL + Edgar_10K_DF['TextURL'].astype(str)


## Function to download the filings 
def download_filings():
    for index, row in Edgar_10K_DF.iterrows(): #Loops through each row to access url and download the file
        url = row['TextURL'] #Read url
        # Replace spaces and / in the company name with underscore as it would be used as the file name
        row['CompanyName'] = row['CompanyName'].replace("/","_") 
        row['CompanyName'] = row['CompanyName'].replace(" ","_")
        folder = './10KQ/' + row['CompanyName'] + '.csv'  #Assign the corresponding company name to the file to be downloaded
        # Download the file from corresponding url
        r = requests.get(url)
        with open(folder , 'wb') as f:  
            f.write(r.content) # Write it to a file

        # Prints status
        print(r.status_code)  
        print(r.headers['content-type'])  
        print(r.encoding) 
        

## Function call
download_filings()





