library(tidyverse)
library(tempdisagg)
library(tsbox)

M1_men <- read.csv("M1_mensual.csv", sep = ";")

str(M1_men)

M1_men <- M1_men %>%
  rename(date = Fecha, M1 = Miles.de.millones.COP)

M1_men$date <- as.Date(M1_men$date, format = "%d/%m/%Y")

#data <- merge(x = M1_sem, y = colcap, all = TRUE)
#View(data)



print(M1_men)


M1_dia <- td(M1_men$M1 ~ 1,conversion = "sum",
             to = 20, method =  "chow-lin-maxlog")
M1_dia <- as.data.frame(predict(M1_dia))
print(M1_dia)
sum(M1_dia)
#M1_dia <- as.data.frame(M1_dia[1:245, ])

#Inflacion#
infla <- read.csv('inflacion_mensual.csv', sep = ";")
print(infla)
str(infla)
View(infla)

infla <- infla %>% 
  rename(inflacion = Porcentaje...., date = Fecha)

infla$date <- as.Date(infla$date, format = "%d/%m/%Y")

infla_dia <- td(infla$inflacion ~ 1,conversion = "first",
             to = 21, method =  "chow-lin-maxlog")
infla_dia1 <- as.data.frame(predict(infla_dia))
print(infla_dia1)
#PIB

pib <- read.csv("pib_real_trimestral.csv", sep = ";")

print(pib)
str(pib)

pib <- pib %>% 
  rename(pib = Miles.de.millones.COP, date = Fecha)

pib$date <- as.Date(pib$date, format = "%d/%m/%Y")

pib_dia <- td(pib$pib ~ 1,conversion = "sum",
                to = 61, method =  "chow-lin-maxlog")
pib_dia <- as.data.frame(predict(pib_dia))
print(pib_dia)
sum(pib_dia)


#Merge
#trm
trm <- read.csv("TRM_diario.csv", sep = ";")
print(trm)
trm <- trm %>% 
  rename(trm = COP.USD, date = Fecha)

trm$date <- as.Date(trm$date, format = "%d/%m/%Y")
#colcap
colcap <- read.csv("colcap.csv", sep = ";")
print(colcap)
colcap <- colcap %>% 
  rename(colcap = Índice, date = Fecha)
colcap$date <- as.Date(colcap$date, format = "%d/%m/%Y")
print(colcap)
#IBR
ibr <- read.csv('IBR_diario.csv', sep = ";")
print(ibr)
str(ibr)
ibr <- ibr %>% 
  rename(ibr = Porcentaje...., date = Fecha)
ibr$date <- as.Date(ibr$date, format = "%d/%m/%Y")
print(ibr)

#data <- rbind(trm, pib_dia, M1_dia, colcap, ibr, infla_dia, )

#Merge
#data <- merge(x = trm, y = pib_dia, all = TRUE)
#print(data)
#data1 <- merge(x = M1_dia, y = colcap, all = TRUE, all.x = TRUE)
#print(data1)
#data2 <- merge(x = ibr, y = infla_dia1, all = TRUE)
#print(data2)

##Exportar datos
#write.csv(trm, "trm.csv")
write.csv(pib_dia, "pib.csv")
write.csv(M1_dia, "M1.csv")
#write.csv(colcap, "colcap.csv")
#write.csv(ibr, "ibr.csv")
write.csv(infla_dia1, "inflacion.csv")
library(quantmod)
oil <- as.data.frame(getSymbols("cl=f"))
print(oil)
getSymbols("NG=F")
getSymbols.yahoo("CL=F",from = "2022-01-01",
                        to = "2022-12-31")
print(CL=F)
write.csv(CL=F, "oil.csv")
