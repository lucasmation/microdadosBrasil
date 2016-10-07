library(dplyr);library(devtools)

wdMB <- ".../microdadosBrasil-RA/microdadosBrasil-RA"
wdCadUnico<- ".../cadastro_unico_novo/CadUnico_V7"

setwd(wdMB)

load_all()


cadUnico_192013_01<- read_data("CadUnico",i = 2013, "domicilios", metadata = read_metadata("CadUnico"),root_path = wdCadUnico)
