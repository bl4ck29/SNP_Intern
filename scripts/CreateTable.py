import pandas
from Utils import GetColumnName, ConvertToSQLDatatype

path_defineDatatype = './TableDescription.xlsx'
file = pandas.ExcelFile(path_defineDatatype)
sheets = file.sheet_names

lst_datatypes = []
for name in sheets:
    data = pandas.read_excel(path_defineDatatype, sheet_name=name, header=1)
    columns = GetColumnName(list(data.columns))
    try:
        data = data.dropna(subset=[columns[0]])
        col_columns = [name.replace(' ', '_') for name in data[columns[0]].tolist()]
        col_datatype = [ConvertToSQLDatatype(i) for i in data[columns[1]].tolist()]
        # print(name, col_columns)
        sql_tablebody = ''
        for i in range(len(col_columns)):
            sql_tablebody += col_columns[i] + ' ' + col_datatype[i] + ',\n'
        sql_command = 'create table {name} ({body})\n'.format(name=name, body=sql_tablebody)
        with open("./SQL_scripts/{0}.sql".format(name), "w") as file:
            file.write(sql_command)
    except KeyError as noColumn:
        print(name, noColumn)