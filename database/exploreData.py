import pandas as pd
from sqlalchemy import create_engine
#from sqlalchemy_utils import database_exists, create_database
import sqlalchemy
import gc
import sys
from datetime import datetime,date

pd.set_option('display.max_columns', None)

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
    return df

#function loads data
def upload(df,table_name):
    df.to_sql(table_name,con=engine,index=False,if_exists='append')
    #engine.dispose()
    print('SUCCESSFULLY LOADED DATA INTO STAGING...')

#df = pd.read_csv('/Users/mac/Downloads/test.csv')
#df = df.loc[df['plate'] == 'HPB3289',]
#print(df.head())


final_df = pd.DataFrame()
c_size = 500000
my_csv = '/Volumes/Extreme SSD/data/platenet/Open_Parking_and_Camera_Violations.csv'
for chunk in pd.read_csv(my_csv,chunksize=c_size):
    df = prepData(chunk)
    df = df.loc[df['plate'] == 'HPB3289',]
    print(df.head())
    if len(df) > 0:
        print('writing')
        final_df = final_df.append(df)
        #df.to_csv('/Users/mac/Downloads/myPlate.csv', index=False)
    else:
        print("b is not greater than a")

final_df.to_csv('/Users/mac/Downloads/myPlate.csv', index=False)

#df = pd.read_csv('/Volumes/Extreme SSD/data/platenet/Open_Parking_and_Camera_Violations.csv', nrows=100000)
#df = prepData(df)

#print(df.head(14))
#print(df.dtypes)

#df.to_csv('/Users/mac/Downloads/test.csv', index=False)

#insert data to staging
#try:
#    upload(df, 'plate_data')
#except Exception as error:
#        print('Caught this error: ' + repr(error))

#print(final_df.head())
#del(df)
#gc.collect()

