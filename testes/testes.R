library(dplyr)
devtools::load_all()
library(microdadosBrasil)

source('~/microdadosBrasil/testes/teste_functions.R', echo=TRUE)
folder<- "PATH HERE"


#Carefull! Function test_download() will delete all files previous inside 'folder'

#Test for Censo da Educacao Superior

teste_download_censo_educacao_superior<- test_download("CensoEducacaoSuperior", folder,1995:1996)
teste<- teste_read_censo_educacao_superior<- test_read("CensoEducacaoSuperior",folder,1995:1996)
