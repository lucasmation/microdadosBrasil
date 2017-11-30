#Carefull! Function test_download() will delete all files previous inside 'folder'

test_report<- function(report, test.folder = "testes/test_results"){



    file.tests<- file.path(test.folder, paste0(report ,"_test_results.csv"))
    results.tests<- data.table::fread(file.tests, sep = ";", dec = c(","))

    if(report == "import_sample"){
    results.tests$time <- gsub(results.tests$time, pattern = ",", replacement = ".") %>% as.numeric()
    }

    return(results.tests)


}

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

    d<- NULL

    t0<- Sys.time()
    try({ d<- download_sourceData(dataset,i = i,unzip = unzip,root_path = folder, replace = T)})
    t1<- Sys.time()




    results_temp<- data.frame(dataset = dataset,
                              period =i,
                              date = today.date,
                              time_download = difftime(t1,t0, units = "secs"),
                              error_download = ifelse(is.null(d), T, !(d$sucess)),
                              size = ifelse(is.data.frame(d), d$size, NA), stringsAsFactors = F)

    results<- bind_rows(results,results_temp)

    if(update_test_results){

      update_test_download(results, test.folder)

    }

  }

  return(results)

}


update_test_import_sample<- function(test_results, test.folder = "testes/test_results"){

  file.tests<- file.path(test.folder, "import_sample_test_results.csv")
  old.tests<- data.table::fread(file.tests, sep = ";", dec = ",")
  old.tests[, priority:= 2]
  test_results <- mutate(test_results, priority = 1)

  tests<- rbind(old.tests, test_results, fill = T)

  tests[, date:= as.Date(date, "%Y-%m-%d")]
  tests<- tests[order(dataset,period,priority, -date)]
  tests[, date:= as.character(date)]
  tests <- tests %>% distinct(dataset,period,ft, .keep_all = T) %>%
                      select(-priority)

  write.csv2(tests, file.tests, row.names = F)

  return(tests)

}

update_test_download<- function(test_results, test.folder = "testes/test_results"){

  file.tests<- file.path(test.folder, "download_test_results.csv")
  old.tests<- data.table::fread(file.tests, sep = ";", dec = ",")

  tests<- rbind(old.tests %>% mutate(pref = 0), test_results %>% mutate(pref = 1), fill = T) %>% data.table

  tests[, date:= as.Date(date, "%Y-%m-%d")]
  tests<- tests[order(dataset,period, -date, -pref)]
  tests[, date:= as.character(date)]
  tests <- tests %>% distinct(dataset, period, .keep_all = T) %>% select(dataset,period,date,time_download, error_download, size)

  write.csv2(tests, file.tests, row.names = F)

  return(tests)

}




test_read <- function(dataset,root_path,periods = NULL,nrows = 100, test.folder = "testes/test_results"){

  results<-data.frame(dataset = character(), period = character(),ft = character(), date = character(), sucess = character(),
                      time = numeric(), size = character(),nrows = integer(), nvars = integer(),
                      stringsAsFactors = F)


  metadata<- read_metadata(dataset)

  if(is.null(periods)){
    periods <- metadata$period
    warnings("As the ' periods ' argument was not inserted all periods  available in metadata will be tested , it may take a few minutes")
  }


  for(i in periods){

    r<- NA
    gc()






    for(ft in get_available_filetypes(dataset,i)){

      results_temp<- results[dataset == "@@@@@",]

      if(is.na(metadata[metadata$period == i,paste0("ft_",ft)])){

        results_temp<-  lapply(results_temp[,], function(x) return(NA)) %>% data.frame

        results_temp[1,'ft']<- ft
        results_temp[1, 'period']<- i
        results_temp[1, 'sucess'] <-  F



      }else{
      t0<- Sys.time()
      read_dataset<- get(paste0("read_",dataset))

      try({ r <- read_dataset(ft = ft,i = i,root_path = root_path, nrows = nrows)})
      t1 <- Sys.time()


      results_temp[1, 'dataset'] <-  dataset
      results_temp[1, 'size'] <-  object.size(r) %>% format(unit = "Mb")
      results_temp[1, 'sucess'] <-  is.data.frame(r)
      results_temp[1, 'time'] <-  difftime(t1,t0, unit = "secs")
      results_temp[1, 'nrows'] <-  ifelse(is.data.frame(r),nrow(r),NA)
      results_temp[1, 'ft'] <-  ft
      results_temp[1, 'period'] <- i
      results_temp[1, 'nvars'] <- ifelse(is.data.frame(r),ncol(r), NA)
      results_temp[1, 'date'] <- Sys.Date() %>% as.character()

      update_test_import_sample(results_temp, test.folder)

      }

      results<- bind_rows(results,results_temp)

    }







  }
  return(results)
}

correct_missing<- function(test_read_results, metadata){

  names(metadata) %>% .[grepl(pattern = "ft_",.)] -> ft_list
  ft_list2<- paste0("error_",ft_list %>% gsub(pattern = "ft_",replacement = ""))


  test_read_results[,ft_list2][is.na(metadata[,ft_list])] <- NA

  return(test_read_results)


}


