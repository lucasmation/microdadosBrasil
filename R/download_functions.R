
#' Download brazilian microdata.
#'
#'
#' @param dataset Standardized name of brazilian public microdadata. See available datasets with get_available_datasets()
#' @param i       Period(year/quarter) to download, use get_available_periods(dataset) to see available periods
#' @param unzip  (optional) logical. Should files be unzipped after download?
#' @param replace (optional) logical. Should an existing version of the data be replaced?
#' @param root_path (optional) a path to the directory where dataset should be downloaded
#'
#' @examples
#' \dontrun{
#'
#' download_sourceData("PNAD", 2014, unzip = T, root_path = "F:/Datasets/PNAD", replace = T)
#'
#'}
#'
#' @import RCurl
#' @export
download_sourceData <- function(dataset, i, unzip=T , root_path = NULL, replace = FALSE){



  sucess = FALSE
  size = NA

  dataset_list<- get_available_datasets()

  #Test if parameters are valid

  if( !(dataset %in% dataset_list ) ) {
  stop(paste0("Invalid dataset. Must be one of the following: ",paste(dataset_list, collapse=", ")) ) }

  metadata <-  read_metadata(dataset)

  i_range<- get_available_periods(metadata)
  if (!(i %in% i_range)) { stop(paste0("period must be in ", paste(i_range, collapse = ", "))) }


  ft_list  <- names(metadata)[grep("ft_", names(metadata))]
  data_file_names<- metadata %>% filter(period == i ) %>% select_(.dots =c(ft_list)) %>% unlist(use.names = FALSE) %>% gsub(pattern = ".+?&", replacement = "")
  data_file_names<- paste0(data_file_names[!is.na(data_file_names)],"$")
  if (!replace) {
    if(any(grepl(pattern = paste0(data_file_names,collapse = "|"), x = list.files(recursive = TRUE, path = ifelse(is.null(root_path), ".", root_path))))) {
      stop(paste0("This data was already downloaded.(check:\n",
                  paste(list.files(pattern = paste0(data_file_names,collapse = "|"),
                             recursive = TRUE,path = ifelse(is.null(root_path), ".", root_path), full.names = TRUE), collapse = "\n"),
                  ")\n\nIf you want to overwrite the previous files add replace=T to the function call."))

    }
  }




  md <- metadata %>% filter(period==i)

  link <- md$download_path
  data_file_names<- md
  if(is.na(link)){stop("Can't download dataset, there are no information about the source")}



  if(!is.null(root_path)){
    if(!file.exists(root_path)){
      stop(paste0("Can't find ",root_path))
    }}

  if(md$download_mode == "ftp"){

    filenames <- RCurl::getURL(link, ftp.use.epsv = FALSE, ftplistonly = TRUE,
                        crlf = TRUE)
    filename<- file_dir<- gsub(link, pattern = "/+$", replacement = "", perl = TRUE) %>% gsub(pattern = ".+/", replacement = "")
    new_dir <- paste(c(root_path,file_dir), collapse = "/")
    dir.create(new_dir)
    filenames<- strsplit(filenames, "\r*\n")[[1]]
    file_links <- paste(link, filenames, sep = "")

    download_sucess <- rep(FALSE, length(filenames))

    max_loops  = 20
    loop_counter = 1

    while(!all(download_sucess) & loop_counter< max_loops){


    for(y in seq_along(filenames)[!download_sucess]){

      dest.files = paste(c(root_path,file_dir, filenames[y],collapse = "/"))
      print(dest.files)
      print(file_links[y])
      download_sucess[y] = FALSE
      try({
          download.file(file_links[y],destfile = dest.files, mode = "wb")
          download_sucess[y] = TRUE


        })

      if(sum(file.info(dest.files)$size) < 100000){

        sucess = F
        if(loop_counter == max_loops - 1){
          message(paste0("Downloaded files for period ", i," on the ", loop_counter, "th try were too small. Possible corruption." ))


        }else{
          message(paste0("Downloaded files for period ", i," on the ", loop_counter, "th try were too small, possible corruption, retrying download..." ))

        }
      }
    }


      loop_counter = loop_counter + 1
    }

    if(!all(download_sucess)){ message(paste0("The download of the following files failed:\n"),
                                       paste(filenames[!download_sucess], collapse = "\n"))}

  }else{

    filename <- link %>% gsub(pattern = ".+/", replacement = "")
    file_dir <- filename %>% gsub( pattern = "\\.zip", replacement = "")
    dest.files <- paste(c(root_path,filename),collapse = "/")
    print(link)
    print(filename)
    print(file_dir)



    max_loops  = 4
    loop_counter = 1

    while(!(sucess) & loop_counter< max_loops){

    try({ download.file(link,destfile = dest.files, mode = "wb")

      sucess = TRUE

    })


    if(sucess == T){
    if(sum(file.info(dest.files)$size) < 100000){

      sucess = F
      if(loop_counter == max_loops - 1){
      message(paste0("Downloaded files for period ", i," on the ", loop_counter, "th try were too small. Possible corruption." ))


      }else{
      message(paste0("Downloaded files for period ", i," on the ", loop_counter, "th try were too small, possible corruption, retrying download..." ))

      }
    }

      loop_counter = loop_counter + 1
    }}


  }



    if (unzip==T & sucess == T){
    # #unzipping the data files (in case not unziped above)
    intern_files<- list.files(paste(c(root_path,file_dir),collapse = "/"), recursive = TRUE,all.files = TRUE, full.names = TRUE)
    zip_files<- intern_files[grepl(pattern = "\\.zip$",x = intern_files)]
    rar_files<- intern_files[grepl(pattern = "\\.rar$",x = intern_files)]
    r7z_files<- intern_files[grepl(pattern = "\\.7z$",x = intern_files)]
    if(length(r7z_files)>0){warning(paste0("There are files in .7z format inside the main folder, please unzip manually: ",paste(r7z_files,collapse = ", ")))}
    if(length(rar_files)>0){warning(paste0("There are files in .rar format inside the main folder, please unzip manually: ",paste(r7z_files,collapse = ", ")))}
    for(zip_file in zip_files){
      exdir<- zip_file %>% gsub(pattern = "\\.zip", replacement = "")
      unzip(zipfile = zip_file,exdir = exdir )
    }

}

  if(all(file.info(paste(c(root_path,filename),collapse = "/"))$isdir)){

    size<- sum(file.info(list.files(paste(c(root_path,filename), collapse = "/"), recursive = TRUE, full.names = T))$size) %>%
    utils:::format.object_size(., "Mb")
  }else{
    size = file.size(paste(c(root_path,filename),collapse = "/")) %>%
      utils:::format.object_size(., "Mb")
  }
    info.output<- data.frame(name = filename, link = link, sucess = sucess, size =  size, stringsAsFactors = F)

  return(info.output)

    }




