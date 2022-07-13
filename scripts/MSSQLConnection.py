import pyodbc

HOST = 'ACER-A315'
DB_NAME = 'ThucTapSNP'
connection_string = 'Driver={SQL Server};Server=%s;Database=%s;Trusted_Connection=yes;'%(HOST, DB_NAME)
connection = pyodbc.connect(connection_string)
cursor = connection.cursor()

import os
path_scripts = './SQL_scripts/'
file_scripts = os.listdir(path_scripts)
for name in file_scripts:
    print(name)
    with open(path_scripts+name) as file:
        command = file.read()
        cursor.execute(command)
connection.commit()
connection.close()