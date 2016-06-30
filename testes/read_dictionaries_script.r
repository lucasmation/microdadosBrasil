
library(stringr)
library(tidyr)

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

save(CensoEscolar, file = paste0(dic_folder, "/CensoEscolar_dics.rda"))


###################### CENSO EDUCACAO SUPERIOR ####################################################

path<-"C:/.../CensoEducacaoSuperior"


setwd(path)
metadata<- read_metadata("CensoEducacaoSuperior")
get_all_dics(metadata)

CensoEducacaoSuperior_dics<- mapply(FUN = get_period_dics, metadata$period, MoreArgs = list(metadata = metadata),SIMPLIFY = FALSE)
names(CensoEducacaoSuperior_dics)<- metadata$period

save(CensoEducacaoSuperior, file = paste0(dic_folder, "/CensoEducacaoSuperior_dics.rda"))

################### PNAD #########################################################################

path<-"C:/.../PNAD"

setwd(path)
metadata<- read_metadata("PNAD")
get_all_dics(metadata)

PNAD_dics<- mapply(FUN = get_period_dics, metadata$period, MoreArgs = list(metadata = metadata),SIMPLIFY = FALSE)
names(PNAD_dics)<- metadata$period

save(PNAD, file = paste0(dic_folder, "/PNAD_dics.rda"))

str(PNAD_dics)





