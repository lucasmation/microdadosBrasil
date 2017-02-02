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
#' @rdname read_dataset
#' @export
read_CadUnico<- function(ft,i,root_path=NULL, file = NULL, vars_subset = NULL){
  data<-read_data(dataset = "CadUnico",ft, i,root_path =  root_path, file = file, vars_subset = vars_subset)

  return(data)
}








