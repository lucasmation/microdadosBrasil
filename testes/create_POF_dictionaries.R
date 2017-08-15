library(stringr)

pof.path <- "C:/Users/b2826073/Documents/Datasets/POF/2002"
pof.path.08 <- "C:/Users/b2826073/Documents/Datasets/POF/2008"


download_sourceData("POF", 2002,root_path =  pof.path)
download_sourceData("POF", 2008,root_path =  pof.path.08)


d<- read_POF("despesa_90dias", 2008, pof.path.08)

d<- read_POF("despesa_12meses", 2002, root_path = pof.path)



dataset.root = pof.path
i = 2002
ft = "T_CADERNETA_DESPESA_S"
package.root = "C:/Users/b2826073/Documents/microdadosBrasil"
dataset<- "POF"

pof_md<- fread(input =

  " ft_|internal_regex
    domicilio|T_domicilio.txt
    morador|T_morador.txt
    condicoes_de_vida|T_condicoes_de_vida.txt
    inventario|T_inventario.txt
    despesa_90dias|T_despesa_90dias.txt
    despesa_12meses|T_despesa_12meses.txt
    outras_despesas|T_outras_despesas.txt
    servico_domestico|T_servico_doms.txt
    caderneta_despesa|t_caderneta_despesa.txt
    despesa_individual|T_despesa.txt
    despesa_veiculo|T_despesa_veiculo.txt
    rendimentos|T_rendimentos.txt
    outros_rendimentos|T_outros_reci.txt
    despesa_esp|T_despesa_esp.txt
  "

)


for(ft in pof_md %>% filter(!is.na(ft_)) %>% .$ft){


  internal_regex<- pof_md[ft_ == (ft), .(internal_regex)] %>% unlist(., use.names = F)


  metadata<- read_metadata("POF") %>% filter(period == 2002)

f <- unlist(strsplit(metadata[metadata$period==i,paste0("ft_",ft)], split='&'))[1]


dics_path <- file.path(dataset.root,
                       paste0(ifelse(is.na(metadata[metadata$period==i,'path']),"",metadata[metadata$period==i,'path']),
                              ifelse(is.na(metadata[metadata$period==i,'path']),"","/"),
                              ifelse(is.na(metadata[metadata$period==i,'inputs_folder']),"",metadata[metadata$period==i,'inputs_folder'])),
                              f)




readChar(dics_path, nchars = 10^6) -> dic.raw


target<- str_extract(dic.raw, pattern = paste0(internal_regex,"[\\d\\D]+?[Ee][Nn][Dd];"))

parses_SAS_import_dic(file = textConnection(target)) -> dic


file.dic = file.path(package.root, "inst", "extdata", dataset, "dictionaries",
                     paste0("import_dictionary_",dataset,"_", ft,"_",i, ".csv"))


fwrite(dic, file.dic, sep = ";")

}


#### Construindo dicionarios para 2008


dataset.root = pof.path.08
i = 2008

package.root = "C:/Users/b2826073/Documents/microdadosBrasil"
dataset<- "POF"

pof_md<- fread(input =

                 " ft_|internal_regex
               domicilio|T_DOMICILIO_S.txt
               morador|T_MORADOR_S.txt
               condicoes_de_vida|T_CONDICOES_DE_VIDA_S.txt
               inventario|T_INVENTARIO_S.txt
               despesa_90dias|T_DESPESA_90DIAS_S.txt
               despesa_12meses|T_DESPESA_12MESES_S.txt
               outras_despesas|T_OUTRAS_DESPESAS_S.txt
               servico_domestico|T_SERVICO_DOMS_S.txt
               caderneta_despesa|T_CADERNETA_DESPESA_S.txt
               despesa_individual|T_DESPESA_INDIVIDUAL_S.txt
               despesa_veiculo|T_DESPESA_VEICULO_S.txt
               rendimentos|T_RENDIMENTOS_S.txt
               outros_rendimentos|T_OUTROS_RECI_S.txt
               aluguel_estimado|T_ALUGUEL_ESTIMADO_S.txt
               "

)


for(ft in pof_md %>% filter(!is.na(ft_)) %>% .$ft){


  internal_regex<- pof_md[ft_ == (ft), .(internal_regex)] %>% unlist(., use.names = F)


  metadata<- read_metadata("POF")

  f <- unlist(strsplit(metadata[metadata$period==i,paste0("ft_",ft)], split='&'))[1]


  dics_path <- file.path(dataset.root,
                         paste0(ifelse(is.na(metadata[metadata$period==i,'path']),"",metadata[metadata$period==i,'path']),
                                ifelse(is.na(metadata[metadata$period==i,'path']),"","/"),
                                ifelse(is.na(metadata[metadata$period==i,'inputs_folder']),"",metadata[metadata$period==i,'inputs_folder'])),
                         f)




  readChar(dics_path, nchars = 10^6) -> dic.raw


  target<- str_extract(dic.raw, pattern = paste0(internal_regex,"[\\d\\D]+?[Rr][Uu][Nn];"))

  parses_SAS_import_dic(file = textConnection(target)) -> dic


  file.dic = file.path(package.root, "inst", "extdata", dataset, "dictionaries",
                       paste0("import_dictionary_",dataset,"_", ft,"_",i, ".csv"))


  fwrite(dic, file.dic, sep = ";")

}


