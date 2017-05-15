
library(stringr)
library(tidyr)


##################
#
# 10/01: This script is outdated, do not try to use it. The function get_all_dics() can be used to facilitate building dictionaries, but we do not have a general approach yet.
#
#

######################################
# This script replicates the generation of the dictionaries used in this package, #
# it reads the SAS dictionaries, store and organize in a list for each dataset,   #
# and save the list as a .rda file
#

# Before running the script you must edit 'dic_folder' and 'path' definitions
# 'dic_folder' is the path to the folder where files gonna be saved
# 'path' is the path where files for each dataset(the folder containing the SAS dictionaries) are stored



dic_folder<- "C:/..."


########################## PNAD CONTINUA ######################################################


path<- "C:/.../PNADContinua"

setwd(path)
metadata<- read_metadata("PNADcontinua")
get_all_dics(metadata)

PNADcontinua_dics<- mapply(FUN = get_period_dics, metadata$period, MoreArgs = list(metadata = metadata),SIMPLIFY = FALSE)
names(PNADcontinua_dics)<- metadata$period

save(PNADcontinua_dics, file = paste0(dic_folder, "/PNADcontinua_dics.rda"))




######################### CENSO ESCOLAR ########################################################

path<-"C:/.../CensoEscolar"


setwd(path)
metadata<- read_metadata("CensoEscolar")
get_all_dics(metadata)

CensoEscolar_dics<- mapply(FUN = get_period_dics, metadata$period, MoreArgs = list(metadata = metadata),SIMPLIFY = FALSE)
names(CensoEscolar_dics)<- metadata$period

save(CensoEscolar_dics, file = paste0(dic_folder, "/CensoEscolar_dics.rda"))


###################### CENSO EDUCACAO SUPERIOR ####################################################

path<-"C:/.../CensoEducacaoSuperior"


setwd(path)
metadata<- read_metadata("CensoEducacaoSuperior")
get_all_dics(metadata)

CensoEducacaoSuperior_dics<- mapply(FUN = get_period_dics, metadata$period, MoreArgs = list(metadata = metadata),SIMPLIFY = FALSE)
names(CensoEducacaoSuperior_dics)<- metadata$period

save(CensoEducacaoSuperior_dics, file = paste0(dic_folder, "/CensoEducacaoSuperior_dics.rda"))

################### PNAD #########################################################################

path<-"C:/Users/b2826073/Documents/Datasets/PNAD"

get_all_dics("PNAD", dataset.root = path, globalEnv = T, write = T)


########################## PME ######################################################


path<- "C:/.../PME"

setwd(path)
metadata<- read_metadata("PME")
get_all_dics(metadata)

PME_dics<- mapply(FUN = get_period_dics, metadata$period, MoreArgs = list(metadata = metadata),SIMPLIFY = FALSE)
names(PME_dics)<- metadata$period

save(PME_dics, file = paste0(dic_folder, "/PME_dics.rda"))

########################## ENEM ######################################################


path<- "C:/Users/b2826073/Documents/Datasets/ENEM"


oldwd<- getwd()
setwd(path)
metadata<- read_metadata("ENEM")
get_all_dics(metadata)


#################### PNS ########################################

path<- path.expand("~/Datasets/PNS")

oldwd<- getwd()

setwd(path)
metadata<- read_metadata("PNS")
get_all_dics(metadata)

write.table(dic_domicilios_2013, file = "import_dictionary_PNS_domicilios_2013.csv", sep = ";", row.names = F)
write.table(dic_pessoas_2013, file = "import_dictionary_PNS_pessoas_2013.csv", sep = ";", row.names = F)





