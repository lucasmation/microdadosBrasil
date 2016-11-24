library(dplyr)
library(stringr)



target_folder<- path.expand("~/PNAD")
result_path<- path.expand("~/samples")

create_sample_file<- function(file, old_dir, new_dir){

  nf<- readLines(file, n = 100)

  new_file<- paste0(new_dir, file %>% str_replace(pattern = old_dir, replacement = ""))

  writeLines(nf, new_file)

}
create_sample_folder<- function(target_folder, result_path){


  files <- target_folder %>% list.files(full.names = TRUE, recursive = TRUE)
  dirs <- target_folder %>% list.dirs(full.names = TRUE, recursive = TRUE)

  dirs<- dirs[-1]

  inner_dirs<- dirs %>% str_replace(pattern = paste0(target_folder,"/"), replacement = "")

  new_dir<- paste(result_path, target_folder %>% str_replace(pattern = ".+/", replacement = ""), sep = "/")

  dir.create(new_dir)

  file_ext<- files %>% str_replace(pattern = ".+\\.", replacement = "")

  data_files<- files[file_ext %>% tolower %in% c("txt", "csv")]


  sapply(inner_dirs, function(x) dir.create(paste(new_dir, x, sep = "/")))



  sapply(data_files, create_sample_file, old_dir = target_folder, new_dir = new_dir)

}


