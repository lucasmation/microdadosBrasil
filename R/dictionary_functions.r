#' Returns fwf dictionary
#'
#' The dictionaries used in this package are stored in lists. get_dictionary() is a wrapper to search dictionaries based on dataset name, period and file type.


#' @param  dataset name of the dataset, between quotes. If a wrong name is set in this parameter you will see a list of the available datasets.
#' @param  i period, usually year
#' @param  ft file type.
#'
#' @examples
#' get_dictionary(dataset = "CensoEscolar", i = 1996, ft = "escola")

#' @export
get_dictionary <- function(dataset, i, ft){
  x<- environment()

  datasets_list<- list.files(system.file("data",package  = "microdadosBrasil"),pattern = "\\.rda") %>%
                  gsub(pattern = "_dics\\.rda", replacement = "")

  if(!dataset %in% datasets_list){stop( paste0("The available datasets are these: ",paste(datasets_list,collapse = ", ")),call. = FALSE)}


  ref <- paste0(dataset,"_dics")

  data(list = list(ref),envir = x)
  dics<- get(ref,envir = x)
  ft_list<- names(dics[[as.character(i)]]) %>% gsub(pattern = "dic_", replacement  = "") %>% gsub( pattern = paste0("_",i), replacement = "")
  ft_list<- ft_list[!is.na(dics[[as.character(i)]])]

  if(!i %in% names(dics)){ stop(paste0("The available periods for this dataset are these: ", paste(names(dics),collapse =", ")),call. = FALSE)}
  if(!ft %in% ft_list){ stop(paste0("The available dictionaries for this period and this dataset are these:  : ", paste(ft_list, collapse = ", ")),call. = FALSE)}

  return(dics[[as.character(i)]][[paste0("dic_",ft,"_",i)]])
}

parses_SAS_import_dic <- function(file){
  dic_sas   <- readLines(file) %>% sapply(FUN = remove_comments) %>% sapply(str_trim) %>% as.data.frame(stringsAsFactors = FALSE)


  names(dic_sas) <- 'a'
  dic_sas %>% filter(grepl("^@",a)) %>%
    extract(a, into=c('int_pos', 'var_name', 'x', 'label'),
            "[[:punct:]\\s+](\\d+)\\s+(\\S+)(?:\\s+([[:graph:]$]+)())?")  %>%
    mutate(int_pos=int_pos %>% as.numeric,
           length=gregexpr("[[:digit:]]+(?=\\.)",x,perl = TRUE) %>% regmatches(x = x) %>% as.numeric,
           decimal_places=gregexpr("(?<=\\.)[[:digit:]]+",x,perl = TRUE) %>% regmatches(x = x) %>% as.numeric) -> dic
  dic %>% mutate(
    decimal_places=ifelse(is.na(decimal_places),0,decimal_places),
    fin_pos= int_pos+length -1,
    col_type=ifelse(is.na(x),'c',
                    ifelse(grepl("\\$",x),'c',
                           ifelse(length<=9 & decimal_places==0,'i','d'))) ,
    CHAR=ifelse(grepl("\\$",x),TRUE,FALSE)
  ) -> dic

  #ALGUNS DICIONARIOS N?O MOSTRAM O TAMANHO PARA ALGUNS CAMPOS, APENAS A POSI??O INICIAL E FINAL
  estimated_length<- dic$int_pos %>% diff %>% c(0)
  dic$length[is.na(dic$length)]<- estimated_length
  estimated_final<- dic$int_pos + dic$length
  dic$fin_pos[is.na(dic$fin_pos)]<- estimated_final[is.na(dic$fin_pos)]

  dic %>% return
}

get_all_dics<- function(metadata){
  #facilita o 'parse' de muitos dicionários ao mesmo tempo antes de coloca-los em uma lista
  #Funciona apenas para diretorios 'bem comportados' como Censo Escolar e PNAD Continua

  for(i in metadata$period){

    if(metadata[metadata$period == i,"format"]== "fwf"){
      print(i)
      dics_path <- paste0(ifelse(is.na(metadata[metadata$period==i,'path']),"",metadata[metadata$period==i,'path']),
                          ifelse(is.na(metadata[metadata$period==i,'path']),"","/"),
                          ifelse(is.na(metadata[metadata$period==i,'inputs_folder']),"",metadata[metadata$period==i,'inputs_folder']))

      #normal file types (ft)
      ft_list <- names(metadata)[grepl(names(metadata) ,pattern = "^ft_")] %>% gsub(pattern = "^ft_",replacement ="")
      for(ft in ft_list){
        f <- unlist(strsplit(metadata[metadata$period==i,paste0("ft_",ft)], split='&'))[1]
        if(!is.na(f)){
          print(paste0(dics_path,'/',f))
          try({assign(paste0('dic_',ft,"_",i),
                      parses_SAS_import_dic(paste0(dics_path,ifelse(dics_path == "","",'/'),f)) ,  envir = .GlobalEnv)})

        }
      }

    }

  }
}


remove_comments<- function(data){
  data %>% gsub(pattern = "^\\s*/\\*.+?\\*/\\s*$" , replacement = "") %>%
    gsub(pattern = "/\\*.+?\\*/" , replacement = "") %>%
    gsub(pattern = ".+?\\*/" , replacement = "") %>%
    gsub(pattern = "/\\*.+$" , replacement = "") %>%

    #A parte comentada removeria coment?rios em todo o arquivo, como os coment?rios est?o sendo usados como "labels" +
    # Est?o sendo removidos apenas aqueles que ocupam uma linha inteira
    return
}


get_individual_dic<- function(ft,i,metadata, dics_path){
  #function to locate dictionaries in workspace, used to store all dictionaries in a list

  f <- unlist(strsplit(metadata[metadata$period==i,paste0("ft_",ft)], split='&'))[1]
  if(!is.na(f)){
    print(paste0(dics_path,'/',f))
    try({assign(paste0('dic_',ft,"_",i),
                parses_SAS_import_dic(paste0(dics_path,ifelse(dics_path == "","",'/'),f)))})
    return(get(paste0('dic_',ft,"_",i)))

  }else{
    return(NA)
  }
}

get_period_dics<- function(i, metadata){
  #function to locate dictionaries in workspace, used to store all dictionaries in a list

  if(metadata[metadata$period == i,"format"]== "fwf"){
    print(i)
    dics_path <- paste0(ifelse(is.na(metadata[metadata$period==i,'path']),"",metadata[metadata$period==i,'path']),
                        ifelse(is.na(metadata[metadata$period==i,'path']),"","/"),
                        ifelse(is.na(metadata[metadata$period==i,'inputs_folder']),"",metadata[metadata$period==i,'inputs_folder']))

    #normal file types (ft)
    ft_list <- names(metadata)[grepl(names(metadata) ,pattern = "^ft_")] %>% gsub(pattern = "^ft_",replacement ="")

    #period_dics<- alply(ft_list,.margins = 1, get_individual_dic2)
    period_dics<- mapply(FUN = get_individual_dic, ft_list,MoreArgs = list(i = i, metadata = metadata, dics_path = dics_path),SIMPLIFY = FALSE)
    names(period_dics)<-  paste0("dic_",ft_list,"_",i)
    return(period_dics)
  }  else{
    return(NA)
  }

}


#Creation of Dataset_dics.rda example
# setwd(path)
# metadatas<- read_metadata("PNADContinua")
# get_dics(metadata)
#
# Dataset_dics<- mapply(FUN = get_period_dics, metadata$period, MoreArgs = list(metadata = metadata),SIMPLIFY = FALSE)
# names(Dataset_dics)<- metadata$period



