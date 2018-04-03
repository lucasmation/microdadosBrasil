#This file contains the wrapper functions, specific for reading each dataset


#' Functions to read most common Brazillian dataset
#'
#' The funtions read_DatasetName read each dataset easily and quickly. The functions gather the import parameters from the DatasetName_metadata_file_harmonization.csv files (availabe at folder extdata) and import dictionaries (available at folder data). Base on this dictionaries and parameters it dispatches the read_data function that reads the file
#'
#' @param ft file type. Indicates the subdataset within the dataset. For example: "pessoa" (person) or "domicílio" (household) data from the "CENSO" (Census). For a list of available ft for the period just type an invalid ft (Ex: ft = 'aasfasf')
#' @param i period. Normally period in YYY format.
#' @param harmonize_varnames Should variable names be harmonized over the periods of the subdataset (ft)
#' @param root_path (optional) a path to the directory where dataset was downloaded
#' @param file (optional) file to read, ignore all metadata in this case
#' @param vars_subset (optional) read only selected variables( named on the dictionary for fwf files or in the first row for delimited files)
#' @param nrows (optional) read only n first rows
#' @param source_file_mark (optional) TRUE/FALSE , if T create a variable with the filename that the observation was imported from, useful for datasets with lots of separated files( CENSO and RAIS)
#' @param UF (optional) only for CENSO and RAIS. Use this option to read only the files for selected brazilian states. c("DF)
#'


#'
#' @return a data.frame containing the imported data.
#' @name read_dataset
NULL




#' @rdname read_dataset
#' @import dplyr
#' @import magrittr
#' @import stringr
#' @export
read_CensoEscolar <- function(ft,i,harmonize_varnames=F,root_path=NULL, file = NULL, vars_subset = NULL, nrows = -1L, source_file_mark = F){


  #selecting dictionaries
  #data_path <- paste0(metadata[metadata$period==i,'path'],'/',metadata[metadata$period==i,'data_folder'])
  #Variable names hamonization
  if (harmonize_varnames==T) {
    var_translator <- read_var_translator('CensoEscolar','escola')
    read_data("CensoEscolar", ft, i, var_translator = var_translator, root_path = root_path, file = file, vars_subset = vars_subset, nrows = nrows, source_file_mark = source_file_mark)
  } else {
    read_data(dataset = "CensoEscolar",ft, i,root_path = root_path, file = file, vars_subset = vars_subset, nrows = nrows, source_file_mark = source_file_mark)
  }

}





#' @rdname read_dataset
#' @export
read_CensoEducacaoSuperior<- function(ft,i,root_path=NULL, file = NULL, vars_subset = NULL, nrows = -1L, source_file_mark = F){
  metadata <-  read_metadata('CensoEducacaoSuperior')




   data<-read_data(dataset = "CensoEducacaoSuperior",ft, i,root_path =  root_path, file = file, vars_subset = vars_subset, nrows = nrows, source_file_mark = source_file_mark)

  return(data)
}


#' @rdname read_dataset
#' @export
read_ENEM<- function(ft,i,root_path=NULL, file = NULL, vars_subset = NULL, nrows = -1L, source_file_mark = F){
  metadata <-  read_metadata('ENEM')




  data<-read_data(dataset = "ENEM",ft, i,root_path =  root_path, file = file, vars_subset = vars_subset, nrows = nrows, source_file_mark = source_file_mark)

  return(data)
}



#' @rdname read_dataset
#' @export
read_CENSO<- function(ft,i,root_path = NULL, file = NULL, vars_subset = NULL, UF = NULL, nrows = -1L, source_file_mark = F){

  metadata <-  read_metadata('CENSO')



  if(is.null(file)){


  # Change the data file information in metadata if UF is selected



  if(!is.null(UF)){

    UF <- paste0("(",paste(UF, collapse = "|"),")")


    metadata[, grep("^ft_", names(metadata))] <-
      lapply(metadata[, grep("^ft_", names(metadata))],
             function(x) gsub(x = x, pattern = "&", replacement = paste0("&",UF,"/")))

  }



  }



  data<-read_data(dataset = "CENSO", ft = ft, metadata = metadata, i = i, root_path = root_path,file = file, vars_subset = vars_subset, nrows = nrows, source_file_mark = source_file_mark)


  return(data)
}

#' @rdname read_dataset
#' @export

read_RAIS<- function(ft, i,root_path = NULL,file = NULL, vars_subset = NULL,UF = NULL, nrows = -1L, source_file_mark = F){

  metadata <-  read_metadata('RAIS')


  if(!is.null(UF)){
    UF <- paste0("(",paste(UF, collapse = "|"),")")
    metadata$ft_vinculos <- metadata$ft_vinculos %>%
      gsub(pattern = "[A-Z]{2}", replacement = UF, fixed = TRUE)}


  data <- read_data(dataset = "RAIS",ft = ft, i = i, metadata = metadata, root_path = root_path,file = file, vars_subset = vars_subset, nrows = nrows, source_file_mark = source_file_mark)

  return(data)
}

#' @rdname read_dataset
#' @export

read_CAGED<- function(ft,i,root_path = NULL,file = NULL, vars_subset = NULL, nrows = -1L, source_file_mark = F){


  data<- read_data(dataset = "CAGED",ft = ft, i = i, root_path = root_path, file = file, vars_subset = vars_subset, nrows = nrows, source_file_mark = source_file_mark)

  return(data)
}




#' @rdname read_dataset
#' @export
#'
read_PNAD<- function(ft,i,root_path=NULL,file = NULL, vars_subset = NULL, nrows = -1L, source_file_mark = F){



  data<-read_data(dataset = "PNAD", ft, i, root_path =  root_path, file = file, vars_subset = vars_subset, nrows = nrows, source_file_mark = source_file_mark)

  return(data)
}

#' @rdname read_dataset
#' @export
read_PME <- function(ft,i, root_path = NULL,file = NULL, vars_subset = NULL, nrows = -1L, source_file_mark = F){

  if(!is.character(i)|!grepl(pattern = "^[0-9]{4}-[0-9]{2}m$", x = i)){
    stop(paste0("The argument 'i' must be a character in the format 2014-01m."))

  }



  data<- read_data(dataset = "PME", ft = ft,i = i, root_path = root_path, file = file, vars_subset = vars_subset, nrows = nrows, source_file_mark = source_file_mark)
  return(data)
}


#' @rdname read_dataset
#' @export
read_POF <- function(ft,i, root_path = NULL,file = NULL, vars_subset = NULL, nrows = -1L, source_file_mark = F){



  if(i %in% c(1987,1995,1997)){

    metadata <- read_metadata("POF")
    data_path <- paste(c(root_path, metadata[metadata$period == i, "path"], metadata[metadata$period == i, "data_folder"], ""), collapse = "/")
    uf<-list.files(paste0(data_path), pattern="x.*txt")

    tudo<-NULL
    for(j in uf){
      dados <- readLines(paste0(data_path,j))
      tudo <-c(tudo,dados)
    }
    casas <- substr(dados,1,2)
    out <- split( dados , f = casas )
    invisible(
      lapply(seq_along(out), function(i)
        write.table(out[[i]],paste0(data_path,names(out)[[i]],".txt"),quote = FALSE,row.names = FALSE, col.names = FALSE)
      )
    )
  }
  data <- read_data(dataset= "POF", ft = ft,i = i, root_path = root_path,file = file, vars_subset = vars_subset, nrows = nrows, source_file_mark = source_file_mark)

  invisible(file.remove(paste0(data_path,names(out),".txt")))

  return(data)



}

#' @rdname read_dataset
#' @export
read_PNADcontinua<- function(ft,i,root_path=NULL,file = NULL, vars_subset = NULL, nrows = -1L, source_file_mark = F){



  data<-read_data(dataset = "PNADcontinua",ft, i,root_path =  root_path, file = file, vars_subset = vars_subset, nrows = nrows, source_file_mark = source_file_mark)

  return(data)
}


#' @rdname read_dataset
#' @export
read_PNS<- function(ft,i,root_path=NULL,file = NULL, vars_subset = NULL, nrows = -1L, source_file_mark = F){



  data<-read_data(dataset = "PNS",ft, i,root_path =  root_path, file = file, vars_subset = vars_subset, nrows = nrows, source_file_mark = source_file_mark)

  return(data)
}


