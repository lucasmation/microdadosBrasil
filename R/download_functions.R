


#' @export
download_sourceData <- function(dataset, i, unzip=T, ft=NULL, dest = NULL, replace = FALSE){
  dataset_list<- system.file("extdata", package = "microdadosBrasil") %>%
    list.files(pattern = "files") %>%
    gsub(pattern = "_.+", replacement = "")

  exists.data <- function(dataset, replace = FALSE) {
    if (replace) {
      if( any(dataset %in% dir() ) == TRUE ) {
        stop(paste0("this data was already downloaded. If you want to overwride add
                    replace=T to the function call"))
      }
    }
  }

  #Test if parameters are valid

  if( !(dataset %in% dataset_list ) ) {
    stop(paste0("Invalid dataset. Must be one of the following: ",paste(dataset_list, collapse=", ")) ) }

  metadata <-  read_metadata(dataset)


  i_min    <- min(metadata$period)
  i_max    <- max(metadata$period)

  if (!(i %in% metadata$period)) { stop(paste0("period must be between ", i_min," and ", i_max )) }


  md <- metadata %>% filter(period==i)

  link <- md$download_path
  if(is.na(link)){stop("Can't download dataset, there are no information about the source")}
  filename <- link %>% gsub(pattern = ".+/", replacement = "")
  file_dir <- filename %>% gsub( pattern = "\\.zip", replacement = "")


  if(!is.null(dest)){
    if(!file.exists(dest)){
      stop(paste0("Can't find ",dest))
    }}

  if(md$download_mode == "ftp"){

    filenames <- getURL(link, ftp.use.epsv = FALSE, ftplistonly = TRUE,
                        crlf = TRUE)

    filenames<- strsplit(filenames, "\r*\n")[[1]]
    filenames <- paste(link, filenames, sep = "")
    for(file in filenames){
      exists.data(file)
      print(paste(c(dest,file),collapse = "/"))
      try(download.file(file,destfile = paste(c(dest,gsub(pattern = ".+?/", replacement = "", file)),collapse = "/")))
    }
  }else{
    exists.data(filename)
    print(link)
    print(filename)
    print(file_dir)

    try(download.file(link,destfile = paste(c(dest,filename),collapse = "/")))
  }
  if (unzip==T){
    #Unzipping main source file:
    unzip(paste(c(dest,filename),collapse = "/") ,exdir = paste(c(dest,file_dir),collapse = "/"))
    # #unzipping the data files (in case not unziped above)
    intern_files<- list.files(paste(c(dest,file_dir),collapse = "/"), recursive = TRUE,all.files = TRUE, full.names = TRUE)
    zip_files<- intern_files[grepl(pattern = "\\.zip$",x = intern_files)]
    rar_files<- intern_files[grepl(pattern = "\\.rar$",x = intern_files)]
    r7z_files<- intern_files[grepl(pattern = "\\.7z$",x = intern_files)]
    if(length(r7z_files)>0){warning(paste0("There are files in .7z format inside the main folder, please unzip manually: ",paste(r7z_files,collapse = ", ")))}
    if(length(rar_files)>0){warning(paste0("There are files in .rar format inside the main folder, please unzip manually: ",paste(r7z_files,collapse = ", ")))}
    for(zip_file in zip_files){
      exdir<- zip_file %>% gsub(pattern = "\\.zip", replacement = "")
      unzip(zipfile = zip_file,exdir = exdir )
    }


    # check data_path for compressed files: .zip, .7z , .rar
    # Unzip the .zip ones
    # Issue warning for unzipping manually the .7z and .rar files
    #
    # }
  }
}



