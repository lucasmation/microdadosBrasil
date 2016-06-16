
#Carefull! Function test_download() will delete all files previous inside 'folder'


test_download<- function(dataset,folder,periods = NULL){


  if(list.files(folder,full.names = TRUE) %>% length() > 0){
    stop(paste0("The folder ",folder,"is not empty, all files will be deleted!"))}

  metadata<- read_metadata(dataset)

  if(is.null(periods)){
    periods <- metadata$period
    warnings("As the ' periods ' argument was not inserted all periods  available in metadata will be tested , it may take a few minutes")
             }


  results<- data.frame()

  for(i in periods){

    d<- NA

    t0<- Sys.time()
    try({ d<- download_sourceData(dataset,i = i,unzip = T,dest = folder)})
    t1<- Sys.time()




    results_temp<- data.frame(period =i,
                              time_download = difftime(t1,t0, units = "secs"),
                              error_download = !is.null(d))

    results<- bind_rows(results,results_temp)


  }

  return(results)

}

test_read <- function(dataset,folder,periods = NULL){

  results<-data.frame()
  metadata<- read_metadata(dataset)

  if(is.null(periods)){
    periods <- metadata$period
    warnings("As the ' periods ' argument was not inserted all periods  available in metadata will be tested , it may take a few minutes")
  }


  for(i in periods){

    r<- NA
    gc()

    ft_list  <- names(metadata)[grep("ft_", names(metadata))]
    ft_list2 <- gsub("ft_","",names(metadata)[grep("ft_", names(metadata))])
    results_temp<- data.frame(period = i)
    names_temp<- c("period")

    for(ft in ft_list2){

      t0<- Sys.time()
      read_dataset<- get(paste0("read_",dataset))

      try({ r <- read_dataset(ft = ft,i = i,root_path = folder)})
      t1 <- Sys.time()


      results_temp<- bind_cols(results_temp,
                               data.frame(
                                 difftime(t1,t0, unit = "secs"),
                                 !is.data.frame(r)))

      names_temp<- c(names_temp,
                     paste0("time_",ft),paste0("error_",ft))
    }

    names(results_temp)<- names_temp

    results<- bind_rows(results,results_temp)



  }
  return(results)
}



