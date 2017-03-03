test_path_arguments<- function(root_path, file){

  #Check for inconsistency in parameters
  if(!is.null(root_path) & !is.null(file)){
    status = 0
    message(paste0("\nPlease, do not specify both the 'root_path' and 'file' parameters to the function. You can:\n",
                   "1) Specify neither the 'root_path' nor the 'file' argument, in this case we will assume that data is in your working directory and the files are named exactly as  they have been downloaded from the source.\n",
                   "2) Specify only the 'root_path' argument, in this case we will assume that data is in the directory specified and it is exactly as it have been downloaded from the source.\n"),
            "3) Specify only the 'file' argument, in this case we will assume that data is in a .txt or .csv file stored in the adress specified by the 'file' parameter.")


  }else{
    if(is.null(root_path) & is.null(file)){
      status = 1
      message(paste0("You haven't specified neither the 'root_path' nor ther 'file' parameters to the function. in this case we will assume that data is in your working directory and the files are named exactly as  they have been downloaded from the source.\n"))


    }else{
      if(is.null(file)){
        status = 2
        message(paste0("You have specified the 'root_path' argument, in this case we will assume that data is in the directory specified and it is exactly as it have been downloaded from the source.\n"))


      }else{
        status = 3

        message(paste0("You have specified the 'file' argument, in this case we will assume that data is in a .txt or .csv file stored in the adress specified by the 'file' parameter.\n"))
        if (!file.exists(file)) { stop("Data not found. Check if you have provided a valid address in the 'file' parameter" )  }
      }
    }
  }

  return(status)

}


check_overlapping <- function(dic){

  check = any(dic$int_pos[-1] <= dic$fin_pos[-dim(dic)[1]])

  return(check)
}



get_available_datasets <- function(){
  datasets_list<- list.files(system.file("extdata", package = "microdadosBrasil"), full.names = TRUE) %>%
    (function(x) return(x[dir.exists(x)])) %>%
    str_replace(pattern = ".+/", replacement = "")

  #datasets_list<- data(package = "microdadosBrasil")$results[,"Item"] %>%
   #gsub(pattern = "_dics", replacement = "")

  return(datasets_list)
}


get_available_periods <- function(dataset, fwfonly = FALSE){


  md = is.data.frame(dataset)

  if(!md){

    dataset  = read_metadata(dataset)

  }
  if(!"period" %in% names(dataset)){

    warning("metadata in wrong format")
    return(NULL)

  }
  if(fwfonly){

    dataset = dataset %>% filter(format == "fwf")

  }

  periods = dataset$period
  return(periods)



}

get_available_filetypes<- function(dataset, period){

  md = is.data.frame(dataset)


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


nodic_overlap <- function(dic, init_pos = "int_pos", fin_pos = "fin_pos")
{

  # Primeiro teste de overlap
  overlap.pos = which(dic[[init_pos]][-1] - dic[[init_pos]][-length(dic[[init_pos]])] != dic[[fin_pos]][-length(dic[[fin_pos]])] - dic[[init_pos]][-length(dic[[init_pos]])] + 1)
  if(length(overlap.pos) > 0){
    dic.pos = dic
    dic.lis = list()
    dic.lis[[1]] = dic[-overlap.pos,]
    for(i in 1:length(overlap.pos)){
      dic.lis[[i+1]] = dic[overlap.pos[i],]
    }
  } else {
    dic.lis = list()
    dic.lis[[1]] = dic
  }
  i = 1:length(dic.lis)
  names(dic.lis) = paste("V", i, sep = "")
  return(dic.lis)
}

