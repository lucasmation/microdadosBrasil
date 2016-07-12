#Scritp to test the functions and metadata of microdadosBrasil. For each dataset, it should generate a data.frame test_dataset with:
# - Size of the dataset for each period and filetype
# - Time of the loading for each period and file type
# - Dummie for error in the loading for each period and file type



folder<- "...\microdadosBrasil\testes\Import\..." # path to the folder where results will be stored

path_PME <- "C:\..." #path to the folder where each dataset is stored
path_PNAD <- "C:\..."
path_RAIS <- "C:\..."
path_CENSO <- "C:\..."
path_CensoEducacaoSuperior <- "C:\..."
path_CensoEscolar <- "C:\..."
path_CAGED <- "C:\..."


#PME

test_PME<-test_read(dataset = "PME", folder = path_PME)
save(test_PME, file = paste0(folder,"/teste_read_PME.rda"))

#PNAD

test_PNAD<- test_read(dataset = "PNAD", folder = path_PNAD)
save(test_PNAD, file = paste0(folder,"/teste_read_PNAD.rda"))

#RAIS

test_RAIS<- test_read(dataset = "RAIS", folder = path_rais)
save(test_RAIS, file = paste0(folder,"/teste_read_RAIS.rda"))

#CENSO

test_CENSO<- test_read(dataset = "CENSO", folder = path_censo)
save(test_CENSO, file = paste0(folder,"/teste_read_CENSO.rda"))

#CENSO EDUCACAO SUPERIOR

test_CensoEducacaoSuperior<- test_read(dataset = "CensoEducacaoSuperior", folder = path_CensoEducacaoSuperior)
save(test_CensoEducacaoSuperior, file = paste0(folder,"/teste_read_CensoEducacaoSuperior.rda"))

#CENSO ESCOLAR

test_CensoEscolar<- test_read(dataset = "CensoEscolar", folder = path_CensoEscolar)
save(test_CensoEscolar, file = paste0(folder,"/teste_read_CensoEscolar.rda"))


#CAGED

test_CAGED<- test_read(dataset = "CAGED", folder = path_caged)
save(test_CAGED, file = paste0(folder,"/teste_read_CAGED.rda"))

