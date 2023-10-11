#####Metodo de interpolacion####

library(tidyverse)
library(tempdisagg)
library(tsbox)
library(tseries)
library(urca)
library(strucchange)

M1_men <- read.csv("M1_mensual.csv", sep = ";")

str(M1_men)

M1_men <- M1_men %>%
  rename(date = Fecha, M1 = Miles.de.millones.COP)

M1_men$date <- as.Date(M1_men$date, format = "%d/%m/%Y")

#data <- merge(x = M1_sem, y = colcap, all = TRUE)
#View(data)



print(M1_men)


M1_dia <- td(M1_men$M1 ~ 1, conversion = "sum",
             to = 20, method =  "chow-lin-maxlog")
M1_dia <- as.data.frame(predict(M1_dia))
print(M1_dia)
sum(M1_dia)
#M1_dia <- as.data.frame(M1_dia[1:245, ])

#Inflacion#
infla <- read.csv('inflacion_mensual.csv', sep = ";")
print(infla)
str(infla)

infla <- infla %>% 
  rename(inflacion = Porcentaje...., date = Fecha)

infla$date <- as.Date(infla$date, format = "%d/%m/%Y")

infla_dia <- td(infla$inflacion ~ 1,conversion = "first",
             to = 21, method =  "chow-lin-maxlog")
infla_dia1 <- as.data.frame(predict(infla_dia))
print(infla_dia1)
sum(infla_dia1)
#PIB

pib <- read.csv("pib_real_trimestral.csv", sep = ";")

print(pib)
str(pib)

pib <- pib %>% 
  rename(pib = Miles.de.millones.COP, date = Fecha)

pib$date <- as.Date(pib$date, format = "%d/%m/%Y")

pib_dia <- td(pib$pib ~ 1, conversion = "sum",
                to = 61, method =  "chow-lin-minrss-ecotrim")
pib_dia <- as.data.frame(predict(pib_dia))
print(pib_dia)
sum(pib_dia)
plot.ts(pib_dia)
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
write.csv(pib_dia, 'pib.csv')
write.csv(trm, "trm.csv")
write.csv(M1_dia, "M1.csv")
#write.csv(colcap, "colcap.csv")
#write.csv(ibr, "ibr.csv")
write.csv(infla_dia1, "inflacion.csv")
library(quantmod)
library(Quandl)
library(tidyverse)

getSymbols("BZ:NMX", src = "google")
oil <- `CL=F`["2022-01-01::2022-12-31"]
oil <- data.frame(oil)
oil <- oil %>% 
  rownames_to_column(var = "Index") %>%
  rename(date = Index)
View(oil)
getSymbols("NG=f", src = "yahoo")
gas <- `NG=F`["2022-01-01::2022-12-31"]
gas <- data.frame(gas)
gas <- gas %>% 
  rownames_to_column(var = "Index") %>%
  rename(date = Index)
View(oil)

write.csv(gas, "gas.csv")
write.csv(oil, "oil.csv")
####Raices unitarias####

#Dicky-fuller

datos <- read.csv('Base.csv')
datos <- na.omit(datos)
adf.test(datos$colcap, k =0)
adf.test(datos$ibr, k = 0)
adf.test(datos$predict.infla_dia., k = 0)
adf.test(datos$predict.M1_dia., k = 0)
adf.test(datos$predict.pib_dia., k = 0)
adf.test(datos$trm, k = 0)
adf.test(datos$ecop, k = 0)
adf.test(datos$oil_COP, k = 0)
adf.test(datos$gas_COP, k = 0)
adf.test(datos$embi, k = 0)

#Philip-perron
pp.test(datos$colcap)
pp.test(datos$ibr)
pp.test(datos$predict.infla_dia.)
pp.test(datos$predict.M1_dia.)
pp.test(datos$predict.pib_dia.)
pp.test(datos$trm)
pp.test(datos$ecop)
pp.test(datos$embi)
pp.test(datos$oil_COP)
pp.test(datos$trm)

for (col in colnames(datos)[-c(1, 2)]) {
  datos[[col]] <- log(datos[[col]])
}

#for (col in colnames(datos)[-c(1, 2)]) {
#  datos[[paste0(col, "_diff")]] <- NA
#}

for (col in colnames(datos)[-c(1, 2)]) {
  datos[[paste0(col, "_diff")]] <- c(NA, diff(datos[[col]]))
}

datos <- datos %>%
  rename(infla = predict.infla_dia._diff, M1 = predict.M1_dia._diff, 
         pib = predict.pib_dia._diff) %>%
  mutate(pib_diff2 = c(NA, NA, diff(predict.pib_dia., differences = 2)))

datos <- na.omit(datos)

adf.test(datos$colcap_diff, k =0)
adf.test(datos$ibr_diff, k = 0)
adf.test(datos$M1, k = 0)
adf.test(datos$pib_diff2, k = 0)
adf.test(datos$infla, k = 0)
adf.test(datos$trm_diff, k = 0)
adf.test(datos$ecop_diff, k = 0)
adf.test(datos$oil_COP_diff, k = 0)
adf.test(datos$gas_COP_diff, k = 0)
adf.test(datos$embi_diff, k = 0)

#Philip-perron
pp.test(datos$colcap_diff)
pp.test(datos$ibr_diff)
pp.test(datos$infla)
pp.test(datos$M1)
pp.test(datos$pib_diff2)
pp.test(datos$trm_diff)
pp.test(datos$ecop_diff)
pp.test(datos$embi_diff)
pp.test(datos$oil_COP_diff)
pp.test(datos$trm_diff)

mean(datos$pib_diff2)

breakpoints()
