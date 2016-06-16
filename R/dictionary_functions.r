#' @export
import_SASdictionary <- function(dataset, i, ft){
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

