#This file contains the wrapper functions, specific for reading each dataset



#' Reads fixed-width file (fwf) file based on dictionary.
#'
#' @param f A fixed-width file (fwf) (normally a .txt file).
#' @import dplyr
#' @import magrittr
read_CensoEscolar <- function(ft,i,harmonize_varnames=F,root_path=NULL){
  metadata <-  read_metadata('CensoEscolar')
  data("CensoEscolar_dics")


  #selecting dictionaries
  data_path <- paste0(metadata[metadata$ano==i,'path'],'/',metadata[metadata$ano==i,'data_folder'])
  #Variable names hamonization
  if (harmonize_varnames==T) {
    var_translator <- read_var_translator('CensoEscolar','escola')
    read_data(ft, i, metadata, var_translator,root_path, dic_list = CensoEscolar_dics)
  } else {
    read_data(ft, i, metadata, root_path = root_path, dic_list = CensoEscolar_dics)
  }

}








read_CensoEducacaoSuperior<- function(ft,i,root_path=NULL){
  metadata <-  read_metadata('CensoEducacaoSuperior')
#   dic<- readRDS(system.file("data","CensoEducacaoSuperior_dics.rds",
#                             package = "microdadosBrasil"))

  data("CensoEducacaoSuperior_dics")



   data<-read_data(ft, i, metadata, dic = CensoEducacaoSuperior_dics,root_path =  root_path)

  return(data)
}


read_CensoIBGE<- function(ft,i,root_path){
  metadata <-  read_metadata('CensoIBGE')

#   dic<- readRDS(system.file("data","CensoIBGE_dics.rds",
#                             package = "microdadosBrasil"))[[as.character(i)]][[paste0("dic_",ft,"_",i)]]

  data("CensoIBGE_dics")



   data<-read_data(ft = ft,i = i,metadata = metadata, dic_list  = CensoIBGE_dics,root_path = root_path)


  return(data)
}






read_POF <- function(ft,i, root_path){
  metadata <-  read_metadata('POF')
  data("POF_dics")


  data<- read_data(ft = ft,i = i,metadata = metadata,dic = POF_dics, root_path = root_path)
  return(data)
}

