#This file contains the wrapper functions, specific for reading each dataset


#' Functions to read most common Brazillian dataset
#'
#' The funtions read_DatasetName read each dataset easily and quickly. The functions gather the import parameters from the DatasetName_metadata_file_harmonization.csv files (availabe at folder extdata) and import dictionaries (available at folder data). Base on this dictionaries and parameters it dispatches the read_data function that reads the file
#'
#' @param ft file type. Indicates the subdataset within the dataset. For example: "pessoa" (person) or "domicílio" (household) data from the "CENSO" (Census). For a list of available ft for the period just type an invalid ft (Ex: ft = 'aasfasf')
#' @param i period. Normally year in YYY format.
#' @param harmonize_varnames Should variable names be harmonized over the years of the subdataset (ft)
#'
#' @return a data.frame containing the imported data.
#' @name read_
NULL

#' @rdname read_
#' @import dplyr
#' @import magrittr
#' @import stringr
#' @export
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







#' @rdname read_
#' @export
read_CensoEducacaoSuperior<- function(ft,i,root_path=NULL){
  metadata <-  read_metadata('CensoEducacaoSuperior')
#   dic<- readRDS(system.file("data","CensoEducacaoSuperior_dics.rds",
#                             package = "microdadosBrasil"))

  data("CensoEducacaoSuperior_dics")



   data<-read_data(ft, i, metadata, dic = CensoEducacaoSuperior_dics,root_path =  root_path)

  return(data)
}

#' @rdname read_
#' @export
read_CENSO<- function(ft,i,root_path){
  metadata <-  read_metadata('CensoIBGE')

#   dic<- readRDS(system.file("data","CensoIBGE_dics.rds",
#                             package = "microdadosBrasil"))[[as.character(i)]][[paste0("dic_",ft,"_",i)]]

  data("CensoIBGE_dics")



   data<-read_data(ft = ft,i = i,metadata = metadata, dic_list  = CensoIBGE_dics,root_path = root_path)


  return(data)
}





#' @rdname read_
#' @export
read_POF <- function(ft,i, root_path){
  metadata <-  read_metadata('POF')
  data("POF_dics")


  data<- read_data(ft = ft,i = i,metadata = metadata,dic = POF_dics, root_path = root_path)
  return(data)
}

