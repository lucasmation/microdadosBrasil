#Carefull! Function test_download() will delete all files previous inside 'folder'


test_download<- function(dataset,folder,periods = NULL, unzip = F, ignore.files = F, update_test_results = T, test.folder = "testes/test_results"){


  if(list.files(folder,full.names = TRUE) %>% length() > 0 & !ignore.files){
    stop(paste0("The folder ",folder,"is not empty!"))}


  metadata<- read_metadata(dataset)
  today.date<- Sys.Date() %>% as.character()

  if(is.null(periods)){
    periods <- metadata$period
    message("As the ' periods ' argument was not inserted all periods  available in metadata will be tested , it may take a few minutes")
  }


  results<- data.frame()

  for(i in periods){

    d<- NA

    t0<- Sys.time()
    try({ d<- download_sourceData(dataset,i = i,unzip = unzip,root_path = folder)})
    t1<- Sys.time()




    results_temp<- data.frame(dataset = dataset,
                              period =i,
                              date = today.date,
                              time_download = difftime(t1,t0, units = "secs"),
                              error_download = is.na(d), stringsAsFactors = F)

    results<- bind_rows(results,results_temp)

    if(update_test_results){

      update_test_download(results, test.folder)

    }

  }

  return(results)

}


update_test_download<- function(test_results, test.folder = "testes/test_results"){

  file.tests<- file.path(test.folder, "download_test_results.csv")
  old.tests<- data.table::fread(file.tests, sep = ";", dec = ",")

  tests<- rbind(old.tests, test_results)

  tests[, date:= as.Date(date, "%Y-%m-%d")]
  tests<- tests[order(dataset,period, -date)]
  tests[, date:= as.character(date)]
  tests <- tests %>% filter(!(duplicated(dataset) & duplicated(period)))

  write.csv2(tests, file.tests, row.names = F)

  return(tests)

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

      if(is.na(metadata[metadata$period == i,paste0("ft_",ft)])){

        results_temp<- bind_cols(results_temp,
                                 data.frame(
                                   NA,
                                   NA,
                                   NA))
        names_temp<- c(names_temp,
                       paste0("time_",ft),paste0("size_",ft),paste0("error_",ft))

      }else{
      t0<- Sys.time()
      read_dataset<- get(paste0("read_",dataset))

      try({ r <- read_dataset(ft = ft,i = i,root_path = folder)})
      t1 <- Sys.time()


      results_temp<- bind_cols(results_temp,
                               data.frame(
                                 difftime(t1,t0, unit = "secs"),
                                 object.size(r) %>% format(unit = "Mb"),
                                 !is.data.frame(r)))

      names_temp<- c(names_temp,
                     paste0("time_",ft),paste0("size_",ft),paste0("error_",ft))
      }
    }

    names(results_temp)<- names_temp

    results<- bind_rows(results,results_temp)



  }
  return(results)
}

correct_missing<- function(test_read_results, metadata){

  names(metadata) %>% .[grepl(pattern = "ft_",.)] -> ft_list
  ft_list2<- paste0("error_",ft_list %>% gsub(pattern = "ft_",replacement = ""))


  test_read_results[,ft_list2][is.na(metadata[,ft_list])] <- NA

  return(test_read_results)


}


