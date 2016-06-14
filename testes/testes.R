library(dplyr)
devtools::load_all()
library(microdadosBrasil)

source('~/microdadosBrasil/testes/teste_functions.R', echo=TRUE)
folder<- "C:/Users/b2826073/Documents/Testes"


#Carefull! Function test_download() will delete all files previous inside 'folder'

#teste_download_censo_escolar<- test_download("CensoEscolar", folder,1995:1996)
teste_read_censo_escolar<- test_read("CensoEscolar",folder,1995:1996)


t<-read_CensoEscolar("escola", 1995, root_path = folder)
