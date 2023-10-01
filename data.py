import pandas as pd


colcap = pd.read_csv("C:/Users/lucho/OneDrive/Escritorio/coyuntura economica/datos/join/colcap.csv")
print(colcap)

ibr = pd.read_csv("ibr.csv")
print(ibr)

inflacion = pd.read_csv("inflacion.csv")
print(inflacion)

M1 = pd.read_csv("M1.csv")
print(M1)

pib = pd.read_csv("pib.csv")
print(pib)

trm = pd.read_csv("trm.csv")
print(trm)
#direc = 'C:/Users/lucho/OneDrive/Escritorio/coyuntura economica/datos/join'

data1 = colcap.merge(ibr, how = "outer", on = 'date')
print(data1)
data1 = data1.join(inflacion, how = "outer")
print(data1)
data1 = data1.drop(["Unnamed: 0_x", "Unnamed: 0_y", 'Unnamed: 0'], axis = 1)
data1 = data1.join(M1, how = "outer")
data1 = data1.drop(["Unnamed: 0"], axis = 1)
data1 = data1.join(pib, how = "outer")
data1 = data1.merge(trm, how = "inner", on = "date")
data1 = data1.drop(["Unnamed: 0_x", "Unnamed: 0_y"], axis = 1)
data1.info()

print(data1)

#import pandas_datareader.data as web
#from pandas_datareader.nasdaq_trader import get_nasdaq_symbols
from datetime import datetime
#import yfinance as yfin
#yfin.pdr_override()
#start = datetime(2022, 1, 1)
#end = datetime(2022, 12, 31)
#
##symbols = get_nasdaq_symbols()
#print(symbols.loc['CL=F'])
#
#oil = web.DataReader('BZ=F', 'yahoo', start, end)

ecop = pd.read_csv('ECOPETROL.CL.csv')
print(ecop)
ecop = ecop.rename({"Date" : "date"}, axis = 1)
ecop = ecop

oil = pd.read_csv('oil.csv', sep=",")
print(oil)

#oil['date'] = [x.replace('.','-') for x in oil['date']]
oil['date'] = pd.to_datetime(oil['date'])
oil = oil.rename({'CL.F.Close' : 'oil'}, axis = 1)
oil = oil.drop(['Unnamed: 0'], axis = 1)


gas = pd.read_csv('gas.csv') #Futuros del gas
print(gas)
#gas = gas.rename({"Fecha" : "date"}, axis = 1)
#gas['date'] = [x.replace('.','-') for x in gas['date']]
gas['date'] = pd.to_datetime(gas['date'])
gas = gas.rename({'NG.F.Close' : 'gas'}, axis = 1)
gas = gas.drop(['Unnamed: 0'], axis = 1)


#data1 = pd.read_excel('data1.xlsx')
#data1 = data1.drop(['oil', 'gas'], axis = 1)
data1 = data1.merge(ecop[['date','Close']])
print(data1)
data1['date'] = pd.to_datetime(data1['date'])
data1 = data1.rename({"Close" : "ecop"}, axis = 1)
data2 = data1.copy()
data1 = data1.merge(oil[['date', 'oil']], how = 'outer',on = 'date')
data1 = data1.merge(gas[['date','gas']], how = 'outer', on = 'date')

#data5 = data5.dropna()
#data1 = data1.sort_values(by = ['date']).reset_index()
data1 = data1.dropna(subset = ['trm'])
print(data1)
data1.info()


num_nulos_por_fila = data1.isna().sum(axis=1)
filas_con_varios_nulos = data1[num_nulos_por_fila > 1]
print(filas_con_varios_nulos)

print(data1)
data1.info()

#for col in ['oil', 'gas']:
#        data1[col] = data1[col].str.replace(',', '.')
#        data1[col] = data1[col].astype(float)


for col in ['oil', 'gas']:
            data1[col+'_COP'] = data1['trm'] * data1[col]
data1 = data1.drop(['Unnamed: 0'], axis = 1)
print(data1)

data1.to_excel('Base1.xlsx')
data1.to_csv('Base.csv')