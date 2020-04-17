import pandas as pd
from sqlalchemy import create_engine
#from sqlalchemy_utils import database_exists, create_database
import sqlalchemy
import gc
import sys
from datetime import datetime,date

#connection and host information
host = 'localhost'
db='platenet'
engine = create_engine('mysql+pymysql://root:password@'+ host+ ':3306/'+ db) #create engine connection
version= sys.version_info[0]

#prep data
def prepData(df):
    df.columns = df.columns.str.replace(' ', '_')
    df.columns = map(str.lower, df.columns)
    #df.judgment_entry_date.fillna('01/07/1971', inplace=True)
    df.issue_date = pd.to_datetime(df.issue_date,errors='coerce').dt.normalize()
    df.judgment_entry_date = pd.to_datetime(df.judgment_entry_date,errors='coerce').dt.normalize()
    df.summons_image = df.summons_image.str.replace('View Summons','')
    df.summons_image = df.summons_image.str.replace('(', '')
    df.summons_image = df.summons_image.str.replace(')', '')
    df.summons_image = df.summons_image.str.replace(' ', '')

    return df

#function loads data
def upload(df,table_name):
    df.to_sql(table_name,con=engine,index=False,if_exists='append')
    #engine.dispose()
    print('SUCCESSFULLY LOADED DATA INTO STAGING...')

#loading
c_size = 10000
my_csv = '/Users/mac/Downloads/test.csv'
for chunk in pd.read_csv(my_csv,chunksize=c_size):
    df = prepData(chunk)
    #insert data to staging
    try:
        upload(df, 'plate_data_stg')
    except Exception as error:
        print('Caught this error: ' + repr(error))

    #print(final_df.head())
    del(df)

gc.collect()

my_data = pd.read_csv('/Users/mac/Downloads/myPlate.csv')
my_data = prepData(my_data)
upload(my_data, 'plate_data_stg')
