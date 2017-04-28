#' Returns fwf dictionary
#'
#' The dictionaries used in this package are stored in lists. get_import_dictionary() is a wrapper to search dictionaries based on dataset name, period and file type.


#' @param  dataset name of the dataset, between quotes. If a wrong name is set in this parameter you will see a list of the available datasets.
#' @param  i period, usually year
#' @param  ft file type.
#'
#' @examples
#' get_import_dictionary(dataset = "CensoEscolar", i = 1996, ft = "escola")

#' @export
get_import_dictionary <- function(dataset, i, ft){
  x<- environment()

  datasets_list<- get_available_datasets()


  if(!dataset %in% datasets_list){stop( paste0("Dataset not available. The available datasets are these: ",paste(datasets_list,collapse = ", ")),call. = FALSE)}

  periods_list<- get_available_periods(dataset = dataset, fwfonly = TRUE)

  if(!i %in% periods_list){
    stop( paste0("Period not available. The available periods for this dataset are these: ",
                 paste(periods_list,collapse = ", ")),call. = FALSE)}

  ft_list<- get_available_filetypes(dataset, i)

  if(!ft %in% ft_list){
    stop( paste0("File type not available. The available file types for this dataset and this period are these: ",
                 paste(ft_list,collapse = ", ")),call. = FALSE)}

  dic.file<- system.file("extdata", dataset,"dictionaries",
                         paste0("import_dictionary_",dataset,"_", ft,"_", i ,".csv"),
                         package = "microdadosBrasil")
  if(file.exists(dic.file)){
 dic<-  read.csv2(dic.file,
            stringsAsFactors = FALSE)

  }else{

    stop("There is no available dictionary for this year. You can help to expand the package creating the dictionary, see more information at https://github.com/lucasmation/microdadosBrasil ")
  }

  return(dic)
}

#' @importFrom stringr str_trim

parses_SAS_import_dic <- function(file){
  dic_sas   <- readLines(file) %>% sapply(FUN = remove_comments) %>% sapply(str_trim) %>% as.data.frame(stringsAsFactors = FALSE)


  names(dic_sas) <- 'a'
  dic_sas %>% filter(grepl("^@",a)) %>%
    tidyr::extract_("a", into=c('int_pos', 'var_name', 'x', 'label'),
                    "[[:punct:]\\s+](\\d+)\\s+(\\S+)(?:\\s+([[:graph:]$]+)())?")  %>%
    mutate_(int_pos= ~as.numeric(int_pos),
            length= ~gregexpr("[[:digit:]]+(?=\\.)",x,perl = TRUE) %>% regmatches(x = x) %>% as.numeric,
            decimal_places= ~gregexpr("(?<=\\.)[[:digit:]]+",x,perl = TRUE) %>% regmatches(x = x) %>% as.numeric) -> dic
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

get_all_dics<- function(dataset,globalEnv = T, write = F, package.root = getwd(), dataset.root = getwd()){
  #facilita o 'parse' de muitos dicionários ao mesmo tempo antes de coloca-los em uma lista
  #Funciona apenas para diretorios 'bem comportados' como Censo Escolar e PNAD Continua

  metadata = read_metadata(dataset)

  for(i in metadata$period){

    if(metadata[metadata$period == i,"format"]== "fwf"){
      print(i)
      dics_path <- file.path(dataset.root,
                          paste0(ifelse(is.na(metadata[metadata$period==i,'path']),"",metadata[metadata$period==i,'path']),
                          ifelse(is.na(metadata[metadata$period==i,'path']),"","/"),
                          ifelse(is.na(metadata[metadata$period==i,'inputs_folder']),"",metadata[metadata$period==i,'inputs_folder'])))

      #normal file types (ft)
      ft_list <- names(metadata)[grepl(names(metadata) ,pattern = "^ft_")] %>% gsub(pattern = "^ft_",replacement ="")
      for(ft in ft_list){
        f <- unlist(strsplit(metadata[metadata$period==i,paste0("ft_",ft)], split='&'))[1]
        if(!is.na(f)){

          if(globalEnv){

          print(paste0(dics_path,'/',f))
          try({assign(paste0('dic_',ft,"_",i),
                      parses_SAS_import_dic(paste0(dics_path,ifelse(dics_path == "","",'/'),f)) ,  envir = .GlobalEnv)})

          }
          if(write){
            file.dic = file.path(package.root, "inst", "extdata", dataset, "dictionaries",
                                 paste0("import_dictionary_PNAD", ft,"_",i, ".csv"))

            fwrite(parses_SAS_import_dic(paste0(dics_path,ifelse(dics_path == "","",'/'),f)),file = file.dic , sep = ";" )
          }

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


parses_SQL_import_dic <- function(file){
  dic_sql   <- readLines(file) %>% sapply(FUN = remove_comments) %>% sapply(str_trim) %>% as.data.frame(stringsAsFactors = FALSE)


  names(dic_sql) <- 'a'
  dic_sql %>% filter(grepl("position",a)) %>%
    tidyr::extract_("a", into=c('var_name','int_pos', 'fin_pos'),
                    "^(.+?)\\s+?position\\s+?[\\(](\\d+):(\\d+)[\\)]") %>%
    mutate_(int_pos= ~as.numeric(int_pos),
            fin_pos= ~as.numeric(fin_pos),
            length= ~fin_pos - int_pos + 1) -> dic
  #             decimal_places=gregexpr("(?<=\\.)[[:digit:]]+",~x,perl = TRUE) %>% regmatches(x = x) %>% as.numeric) -> dic
  #   dic %>% mutate(
  #     decimal_places=ifelse(is.na(decimal_places),0,decimal_places),
  #     fin_pos= int_pos+length -1,
  #     col_type=ifelse(is.na(x),'c',
  #                     ifelse(grepl("\\$",x),'c',
  #                            ifelse(length<=9 & decimal_places==0,'i','d'))) ,
  #     CHAR=ifelse(grepl("\\$",x),TRUE,FALSE)
  #   ) -> dic

  #ALGUNS DICIONARIOS N?O MOSTRAM O TAMANHO PARA ALGUNS CAMPOS, APENAS A POSI??O INICIAL E FINAL
  #   estimated_length<- dic$int_pos %>% diff %>% c(0)
  #   dic$length[is.na(dic$length)]<- estimated_length
  #   estimated_final<- dic$int_pos + dic$length
  #   dic$fin_pos[is.na(dic$fin_pos)]<- estimated_final[is.na(dic$fin_pos)]
  #
  dic %>% return
}


#Creation of Dataset_dics.rda example
# setwd(path)
# metadatas<- read_metadata("PNADContinua")
# get_dics(metadata)
#
# Dataset_dics<- mapply(FUN = get_period_dics, metadata$period, MoreArgs = list(metadata = metadata),SIMPLIFY = FALSE)
# names(Dataset_dics)<- metadata$period



