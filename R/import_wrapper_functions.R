#This file contains the wrapper functions, specific for reading each dataset


#' Functions to read most common Brazillian dataset
#'
#' The funtions read_DatasetName read each dataset easily and quickly. The functions gather the import parameters from the DatasetName_metadata_file_harmonization.csv files (availabe at folder extdata) and import dictionaries (available at folder data). Base on this dictionaries and parameters it dispatches the read_data function that reads the file
#'
#' @param ft file type. Indicates the subdataset within the dataset. For example: "pessoa" (person) or "domicílio" (household) data from the "CENSO" (Census). For a list of available ft for the period just type an invalid ft (Ex: ft = 'aasfasf')
#' @param i period. Normally period in YYY format.
#' @param harmonize_varnames Should variable names be harmonized over the periods of the subdataset (ft)
#'
#' @return a data.frame containing the imported data.
#' @name read_dataset
NULL




#' @rdname read_dataset
#' @import dplyr
#' @import magrittr
#' @import stringr
#' @export
read_CensoEscolar <- function(ft,i,harmonize_varnames=F,root_path=NULL){
  metadata <-  read_metadata('CensoEscolar')
  data("CensoEscolar_dics")


  #selecting dictionaries
  data_path <- paste0(metadata[metadata$period==i,'path'],'/',metadata[metadata$period==i,'data_folder'])
  #Variable names hamonization
  if (harmonize_varnames==T) {
    var_translator <- read_var_translator('CensoEscolar','escola')
    read_data(ft, i, metadata, var_translator,root_path, dic_list = CensoEscolar_dics)
  } else {
    read_data(ft, i, metadata, root_path = root_path, dic_list = CensoEscolar_dics)
  }

}





#' @rdname read_dataset
#' @export
read_CensoEducacaoSuperior<- function(ft,i,root_path=NULL){
  metadata <-  read_metadata('CensoEducacaoSuperior')
#   dic<- readRDS(system.file("data","CensoEducacaoSuperior_dics.rds",
#                             package = "microdadosBrasil"))

  data("CensoEducacaoSuperior_dics")



   data<-read_data(ft, i, metadata, dic = CensoEducacaoSuperior_dics,root_path =  root_path)

  return(data)
}



#' @rdname read_dataset
#' @export
read_CENSO<- function(ft,i,root_path = NULL, UF = NULL){

  metadata <-  read_metadata('CensoIBGE')

  root_path<- ifelse(is.null(UF),
                     root_path,
                     paste0(ifelse(is.null(root_path),getwd(),root_path),"/",UF))
  if(!file.exists(root_path)){
    stop("Data not found, check if you provide a valid root_path or stored the data in your current working directory.")
  }

  data("CensoIBGE_dics")

  data<-read_data(ft = ft,i = i,metadata = metadata, dic_list  = CensoIBGE_dics,root_path = root_path)


  return(data)
}

read_RAIS<- function(ft,i,root_path){

  metadata<- read_metadata("RAIS")
  data<- read_data(ft = ft, i = i, metadata = metadata, dic_list = NULL, root_path = root_path)

  return(data)
}



#' @rdname read_dataset
#' @export
read_PNAD<- function(ft,i,root_path=NULL){
  metadata <-  read_metadata('PNAD')

  data("PNAD_dics")

  data<-read_data(ft, i, metadata, dic = PNAD_dics,root_path =  root_path)

  return(data)
}


#' @rdname read_dataset
#' @export
read_POF <- function(ft,i, root_path){
  metadata <-  read_metadata('POF')
  data("POF_dics")


  data<- read_data(ft = ft,i = i,metadata = metadata,dic = POF_dics, root_path = root_path)
  return(data)
}

#' @rdname read_dataset
#' @export
read_PNADcontinua<- function(ft,i,root_path=NULL){

  metadata <-  read_metadata('PNADcontinua')

  data("PNADcontinua_dics")



  data<-read_data(ft, i, metadata, dic = PNADcontinua_dics,root_path =  root_path)

  return(data)
}


