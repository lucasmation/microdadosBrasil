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
read_CensoEscolar <- function(ft,i,harmonize_varnames=F,root_path=NULL, file = file){


  #selecting dictionaries
  #data_path <- paste0(metadata[metadata$period==i,'path'],'/',metadata[metadata$period==i,'data_folder'])
  #Variable names hamonization
  if (harmonize_varnames==T) {
    var_translator <- read_var_translator('CensoEscolar','escola')
    read_data(ft, i, metadata, var_translator,root_path, dic_list = CensoEscolar_dics)
  } else {
    read_data(dataset = "CensoEscolar",ft, i,root_path = root_path, file = file)
  }

}





#' @rdname read_dataset
#' @export
read_CensoEducacaoSuperior<- function(ft,i,root_path=NULL, file = NULL){
  metadata <-  read_metadata('CensoEducacaoSuperior')




   data<-read_data(dataset = "CensoEducacaoSuperior",ft, i,root_path =  root_path, file = file)

  return(data)
}



#' @rdname read_dataset
#' @export
read_CENSO<- function(ft,i,root_path = NULL, file = NULL, UF = NULL){

  metadata <-  read_metadata('CENSO')

  if(is.null(file)){
  root_path<- ifelse(is.null(UF),
                     root_path,
                     paste0(ifelse(is.null(root_path),getwd(),root_path),"/",UF))
  if(!file.exists(root_path)){
    stop("Data not found, check if you provided a valid root_path or stored the data in your current working directory.")
  }
  }



  data<-read_data(dataset = "CENSO", ft = ft,i = i, root_path = root_path,file = file)


  return(data)
}

#' @rdname read_dataset
#' @export

read_RAIS<- function(ft, i,root_path = NULL,file = NULL,UF = NULL){

  metadata <-  read_metadata('RAIS')


  if(!is.null(UF)){
    UF <- paste0("(",paste(UF, collapse = "|"),")")
    metadata$ft_vinculos <- metadata$ft_vinculos %>%
      gsub(pattern = "[A-Z]{2}", replacement = UF, fixed = TRUE)}

  if(is.null(ft)){
    ft<-   names(metadata)[grepl("ft_", names(metadata))] %>%
     gsub(pattern = "ft_", replacement = "") %>% .[-1]
  }

  if(length(ft)>1){
    data<- lapply(X = ft,FUN = read_data, i = i, metadata = metadata, dic_list = NULL, root_path = root_path) %>% bind_rows
  }
  data<- read_data(dataset = "RAIS",ft = ft, i = i, metadata = metadata, root_path = root_path,file = file)

  return(data)
}

#' @rdname read_dataset
#' @export

read_CAGED<- function(ft,i,root_path = NULL,file = NULL){


  data<- read_data(dataset = "CAGED",ft = ft, i = i, dic_list = NULL, root_path = root_path, file = file)

  return(data)
}




#' @rdname read_dataset
#' @export
#'
read_PNAD<- function(ft,i,root_path=NULL,file = NULL){



  data<-read_data(dataset = "PNAD", ft, i, root_path =  root_path, file = file)

  return(data)
}

#' @rdname read_dataset
#' @export
read_PME <- function(ft,i, root_path = NULL,file = NULL){

  if(!is.character(i)|!grepl(pattern = "^[0-9]{4}\\.[0-9]{2}$", x = i)){
    stop(paste0("The argument 'i' must be a character in the format YYYY.MM"))

  }



  data<- read_data(dataset = "PME", ft = ft,i = i, root_path = root_path, file = file)
  return(data)
}


#' @rdname read_dataset
#' @export
read_POF <- function(ft,i, root_path = NULL,file = NULL){


  data<- read_data(dataset= "POF", ft = ft,i = i, root_path = root_path,file = file)
  return(data)
}

#' @rdname read_dataset
#' @export
read_PNADcontinua<- function(ft,i,root_path=NULL,file = NULL){



  data<-read_data(dataset = "PNADcontinua",ft, i,root_path =  root_path, file = file)

  return(data)
}


