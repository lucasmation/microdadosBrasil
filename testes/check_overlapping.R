check_overlapping <- function(dic){

  check = any(dic$int_pos[-1] <= dic$fin_pos[-dim(dic)[1]])

  return(check)
}




c <-  data.frame()

for(dataset in get_available_datasets()){
  for(i in get_available_periods(dataset, fwfonly = TRUE)){
    for(ft in get_available_filetypes(dataset,i))


      print(i)
    print(ft)
    d<- data.frame(
      `dataset` = dataset,
      `i` = i,
      `ft` = ft,
      overlapping = check_overlapping(get_import_dictionary(dataset,i,ft)), stringsAsFactors = FALSE)

    d[,]<- lapply(d[,], as.character)

    c<- bind_rows(c, d
    )

  }


}


c$overlapping %>% as.logical() %>% as.numeric %>% sum()
(filter(c, overlapping == "TRUE"))
