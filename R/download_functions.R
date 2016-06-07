

#' @export
get_sourceData <- function(dataset, i, unzip=T){
  dataset_list <- c('PNAD','CENSO','POF','CensoEscolar','CensoEducacaoSuperior')
  if( !(dataset %in% dataset_list ) ) {
    stop(paste0("Invalid dataset. Must one of the following: ",paste(ft_list2, collapse=", ")) ) }
  metadata <-  read_metadata(dataset)
  #Test if parameters are valid

  md <- metadata %>% filter(year==i)
  link <- md$download_path
  filename <- link %>% gsub(pattern = ".+/", replacement = "")
  file_dir <- filename %>% gsub( pattern = "\\.zip", replacement = "")
print(link)
print(filename)
print(file_dir)

  download.file(link,destfile = filename)
  # if (unzip==T){
  #   #Unzipping main source file:
  #   unzip(filename, exdir = file_dir)
  #   # #unzipping the data files (in case not unziped above)
  #   # check data_path for compressed files: .zip, .7z , .rar
  #   # Unzip the .zip ones
  #   # Issue warning for unzipping manually the .7z and .rar files
  #
  # }
}



