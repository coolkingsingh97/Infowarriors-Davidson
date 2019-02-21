from bs4 import BeautifulSoup
import pandas as pd
import numpy


henryHTML = open('./10KQ/HENRY_SCHEIN_INC.txt', 'r+')

soup = henryHTML.read()
bs = BeautifulSoup(soup,"html.parser")


#Remove ASCII-Encoded segments – All document segment <TYPE> tags of GRAPHIC, ZIP, EXCEL, JSON, and PDF
segments_to_be_removed = ['GRAPHIC', 'ZIP', 'EXCEL', 'JSON', 'PDF']

for tag in bs.find_all('type'):
    newtag = str(tag.find(text=True))
    print(newtag)
    if (newtag.rstrip() in segments_to_be_removed):
        tag.parent.decompose()



def removeTags(tagToRemove):
    for tag in bs.find_all(tagToRemove):
        tag.decompose()
        
#Removing all <TR>, <TD>, <FONT>, and <XBRL> tags
tags_to_be_removed = ['tr', 'td', 'font', 'xbrl']        

for tags in tags_to_be_removed:
    removeTags(tags)        