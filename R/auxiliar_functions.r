


get_available_datasets <- function(){


  datasets_list<- data(package = "microdadosBrasil")$results[,"Item"] %>%
    gsub(pattern = "_dics", replacement = "")

  return(datasets_list)
}


get_available_periods <- function(dataset, fwfonly = FALSE){


  if(!is.data.frame(dataset)) { md = FALSE}

  if(!md){

    dataset  = read_metadata(dataset)


  }
  if(!"period" %in% names(dataset)){

    warning("data.frame in wrong format")
    return(NULL)

  }
  if(fwfonly){

    dataset = dataset %>% filter(format == "fwf")

  }

  periods = dataset$period
  return(periods)



}

get_available_filetypes<- function(dataset, period){

  if(!is.data.frame(dataset)) { md = FALSE}

  if(!md){

    dataset  = read_metadata(dataset)


  }
  if(all(!grepl(pattern = "^ft_",names(dataset)))){

    warning("metadata in wrong format")
    return(NULL)

  }

  filetypes = dataset[ dataset$period == period,] %>%
    subset(select = !is.na(.)[1,]) %>% names() %>%
    subset(grepl(pattern = "^ft_", x = .)) %>%
    gsub(pattern = "^ft_", replacement = "", x = .)
  return(filetypes)

}



