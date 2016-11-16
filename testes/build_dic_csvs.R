for (dataset in c("CAGED")){

  print(dataset)

  dir.create(paste0("inst/extdata/",dataset))
  dir.create(paste0("inst/extdata/",dataset, "/dictionaries"))

  #md<- read_metadata(dataset)

 # write.table()

  for(period in get_available_periods(dataset,fwfonly = TRUE)){

    print(period)

    for(ft in get_available_filetypes(dataset,period)){

       print(ft)

      dic<- get_import_dictionary(dataset,period,ft)



    old_file =  paste0("inst/extdata/",
                           dataset ,
                           "/dictionaries/",
                           dataset,
                           "_",
                           ft,"_",
                           period,
                           "_dictionary.csv")

    unlink(old_file)

     file = paste0("inst/extdata/",
                     dataset ,
                     "/dictionaries/import_dictionary_",
                     dataset,
                     "_",
                     ft,"_",
                     period, ".csv")

    write.table(x = dic,file = file,
                  row.names = FALSE, sep = ";")

      #unlink(x  = paste0("inst/extdata/dictionaries/",dataset,"_", ft,"_",period,"_dictionary.csv"))

    }
  }

}

# for (dataset in get_available_datasets()){
#   print(dataset)
#   for(period in get_available_periods(dataset,fwfonly = TRUE)){
#     print(period)
#     for(ft in get_available_filetypes(dataset,period)){
#       print(ft)
#       dic<- get_import_dictionary(dataset,period,ft)
#
#
#
#       #write.table(dic, file = paste0("inst/extdata/dictionaries/",dataset,"_", ft,"_",period,"_dictionary.csv"),row.names = FALSE)
#       unlink(x  = paste0("inst/extdata/dictionaries/",dataset,"_", ft,"_",period,"_dictionary.csv"))
#
#     }
#   }
#
# }
