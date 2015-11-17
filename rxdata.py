# -*- coding: utf-8 -*-
"""
Created on Fri Oct 16 18:10:42 2015

@author: nlovejoy
"""

import pandas as pd
import numpy as np
import re
import json

rxdata = pd.read_json("/Users/nlovejoy/Documents/Grad School/Yale SHP/Classes/Fall-15/Intro_to_DBs/rxdata/rx_crawl3.json")

rxdata['_pageUrl'] = rxdata['_pageUrl'].astype(str)
rxdata['brand'] = rxdata['brand'].astype(str)
rxdata['description'] = rxdata['description'].astype(str)
rxdata['dose'] = rxdata['dose'].astype(str)
rxdata['generic'] = rxdata['generic'].astype(str)
rxdata['pop'] = rxdata['pop'].astype(str)
rxdata['price_trend'] = rxdata['price_trend'].astype(str)
rxdata['goodrx_price'] = rxdata['goodrx_price'].astype(str)

#pulling the drug category out of the page URL
rxdata['category'] = rxdata['_pageUrl'].map(lambda x: x.lstrip('http://www.goodrx.com/'))

#Pulling the only numbers out of the pop string, then converting them to int
rxdata['pop2'] = rxdata['pop'].map(lambda x: re.findall('\d+', x))
rxdata['pop2'] = [map(int, x) for x in rxdata['pop2']]

#cleaning up datafields
rxdata['brand2'] = rxdata['brand'].map(lambda x: x.lstrip("[u'"))
rxdata['brand2'] = rxdata['brand2'].map(lambda x: x.rstrip("']"))

rxdata['generic2'] = rxdata['generic'].map(lambda x: x.lstrip("[u'"))
rxdata['generic2'] = rxdata['generic2'].map(lambda x: x.rstrip("']"))

rxdata['goodrx_price2'] = rxdata['goodrx_price'].map(lambda x: x.lstrip("[u'"))
rxdata['goodrx_price2'] = rxdata['goodrx_price2'].map(lambda x: x.rstrip("']"))

#cleaning unicode markers out of dose string, creating dose2 field, removing left and right stuff, creating array of dose and units
rxdata['dose2'] = rxdata['dose'].map(lambda x: x.lstrip("[u\'<i rel="))
rxdata['dose2'] = rxdata['dose2'].map(lambda x: x.lstrip('"tooltip" title="The GoodRx Fair Price represents the maximum price that a consumer, with or without insurance, should pay for this drug at a local pharmacy. Insurance co-pays are typically less. Price based on '))
rxdata['dose2'] = rxdata['dose2'].map(lambda x: x.rstrip('class="ico ico-question-black tooltip-fair-price op-30 margin-left-s"></i>\']'))
rxdata['dose2'] = rxdata['dose2'].map(lambda x: x.rstrip(' (generic if available).'))
rxdata['dose2'] = rxdata['dose2'].str.split(', ')

#cleaning price trend data
rxdata['price_trend2'] = rxdata['price_trend'].map(lambda x: x.replace('"', ''))
s = pd.DataFrame(rxdata.price_trend2.str.split('values=').tolist(), columns="other prices".split())
s['prices'] = s['prices'].str.replace("></div>']","").astype(str)
s['prices'] = s['prices'].str.split(',')
s['prices'] = s['prices'].apply(lambda x:[i.split(':') for i in x])
rxdata['price_trend2'] = s['prices']

#this was messing around trying to split arrays
#s2 = s['prices']
#s['prices'] = s['prices'].map(lambda x: x.split(':'))
#s['prices'] = s['prices'].apply(lambda x:[i.split(':') for i in x])

rxdata.brand2[1]
rxbrand.brand2[1]
dtype.rxbrand['brand2']
rxdata.price_trend2[1]

#importing and cleaning rxbrand data (this has gereric/ brand info)
rxbrand = pd.read_csv("/Users/nlovejoy/Documents/Grad School/Yale SHP/Classes/Fall-15/Intro_to_DBs/rxdata/goodrx_brand_info.csv")
rxbrand['molecule2'] = rxbrand['molecule'].str.replace("(","").astype(str)
rxbrand['molecule2'] = rxbrand['molecule2'].str.replace(")","").astype(str)
rxbrand['brand2'] = rxbrand['trade1'].astype(str)

#merging rxbrand and rxdata
import sys
reload(sys)
sys.setdefaultencoding("utf8")

rxmerge= pd.merge(rxdata, rxbrand, how='left', on='brand2')
rxmerge.to_csv("/Users/nlovejoy/Documents/Grad School/Yale SHP/Classes/Fall '15/Intro_to_DBs/rxdata/rxmerge.csv", sep='\t')

#cleaning out unnecessary columns
rxmerge2= rxmerge.drop(['_connectorVersionGuid','_input','_outputTypes','_pageUrl_x','_resultNumber_x','_source_x','_widgetName_x','_num_y','_widgetName_y','_source_y','_resultNumber_y','_pageUrl_y','molecule','brand','generic','goodrx_price','pop','price_trend','dose_x','_num_x','dose_y'], 1)

#export rxmerge2 as JSON
rxmerge2.to_json("/Users/nlovejoy/Documents/Grad School/Yale SHP/Classes/Fall-15/Intro_to_DBs/rxdata/rxmerge2.json")

#export data to mysql
import MySQLdb
con = 
rxmerge2.to_sql('drugs', con, )


rxmerge.dose2[0][1]
def column(matrix, i):
    return [row[i] for row in matrix]
dose = pd.DataFrame(columns = ['index','dose','units'])
dose['dose'] = column(rxmerge['dose2'],0)
dose['units'] = column(rxmerge['dose2'],1)
dose['index'] = dose.index
