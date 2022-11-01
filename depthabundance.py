#! usr/pyenv/python3

import sys
import pandas as pd

#Read the command-line argument passed to the script
depthfile = sys.argv[1]

#Read the system argument file and create dataframe
df = pd.read_csv(depthfile, sep='\t')

#Create a separate dataframe for the contigName column
names = df[['contigName']]

#Loop over all columns in the dataframe
for column in df.columns:
    
    #Conditional to only select columns with a title that ends with bam
    if column.endswith('bam'):

        #If column ends with bam, create a separate dataframe of that column
        bamcolumn = df[column]

        #Create a new dataframe which combines the contignames column and one of the columns that ends with bam
        combined = [names, bamcolumn]

        #Create a new dataframe that is the concatenation of the names and bamcolumn
        result = pd.concat(combined,axis=1,join='inner')

        #Write to a csv that is titled after the column
        result.to_csv(column+'.txt',sep='\t', header=None, index=False)
