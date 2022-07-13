from configparser import ConfigParser
from sqlalchemy import create_engine
import urllib.parse, pandas

config = ConfigParser()
config.read('./assert/SQLConnection.ini')
HOST, PORT, DB_NAME, USERNAME, PASSWORD = config['DWH_DATAMART'].values()
params = urllib.parse.quote_plus('DRIVER={ODBC Driver 17 for SQL Server};SERVER=%s,%s;DATABASE=%s;UID=%s;PWD=%s'%(HOST, PORT, DB_NAME, USERNAME, PASSWORD))
dwh_engine = create_engine('mssql+pyodbc:///?odbc_connect=%s'%params)

d_date = pandas.read_sql('select * from d_DATE', dwh_engine)
print(d_date.loc[
    (d_date['YEAR']==2019) &
    (d_date['MONTH'] == 12)
]['DATE_ID'].tolist()[0])
# import json
# from Utils import ConvertToSQLDatatype

# dct = {
#     'number\\([0-9]+,[0-9]+\\)': ['number', 'numeric'],
#     '^date$': ['date', 'datetime'],
#     'byte.$': ['byte', ''],
#     '^number\\([0-9]\\)$': ['', 'int'],
#     '^varchar2': ['varchar2', 'varchar']}
# with open('./assert/ConvertToSQL.json', 'w') as file:
#     json.dump(dct, file)

# print(ConvertToSQLDatatype('int identity (0, 1)', dct))