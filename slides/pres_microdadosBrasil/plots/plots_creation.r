library(ggplot2)
library(dplyr)
library(ggthemes)


#CRIAR BASE ÚNICA

tread_PME_local<- format_results(teste_PME) %>% 
  mutate( local = "Local", dataset = "PME") %>% 
  mutate_each('as.character', period) %>% 
  mutate_each(funs(rm_mb),size) %>% 
  mutate_each("as.numeric", time)

tread_POF_local <- mutate(teste_read_POF, local = "Local", dataset = "POF") %>% 
  rename(ft = file)%>% 
  mutate_each("as.character", period)  %>% 
  mutate_each(funs(rm_mb), size) %>% 
  mutate_each("as.numeric", time) %>% 
  mutate_each("as.logical", error)

tread_PNADContinua_local<- teste_PNADContinua %>% format_results() %>%
  mutate( local = "Local", dataset = "PNADContinua")%>%
    mutate_each('as.character', period) %>% 
    mutate_each(funs(rm_mb),size) %>% 
    mutate_each("as.numeric", time)
    
 tread_CensoEducacaoSuperior_local<-  teste_read_CensoEducacaoSuperior %>% format_results %>%
   mutate( local = "Local", dataset = "CensoEducacaoSuperior")%>%
   mutate_each('as.character', period) %>% 
   mutate_each(funs(rm_mb),size) %>% 
   mutate_each("as.numeric", time)

 tread_PNAD_local<- teste_read_PNAD %>% format_results %>%
   mutate( local = "Local", dataset = "PNAD")%>%
   mutate_each('as.character', period) %>% 
   mutate_each(funs(rm_mb),size) %>% 
   mutate_each("as.numeric", time)

 
#teste_read_CAGED_local
 
tread_CENSO_servidor <- teste_CensoIBGE_sstata2local_read %>% 
  rename(period = year) %>% format_results %>% 
  mutate_each('as.character', period) %>% 
  mutate(dataset= "CENSO", local = "Servidor")


#teste_read_CensoEducacaoSuperior_servidor
#teste_read_CensoEscolar_servidor
#teste_read_POF_servidor
#teste_read_PNAD_servidor
#teste_read_CAGED_servidor
#teste_read_PME_servidor
#teste_read_RAIS_servidor - sem espaço

all_tests<- lapply(ls()[grepl(ls(), pattern = "tread")],get) %>% bind_rows

lapply(ls()[grepl(ls(), pattern = "teste_read")],get) %>% lapply(str)->x


gdata<- filter(all_tests, !is.na(error) | error != TRUE) %>% mutate(key = paste0(dataset,"-",ft))
gdata<- filter(gdata,!(time < 60 & period == 2000)) # Retirada de valores errados do Censo

plot3<-
ggplot(gdata %>% filter(time<60  & !error & dataset != "CENSO") , aes(x = size, y = time, color = key)) + 
  geom_point() + labs(title = "Desempenho das bases de dados com tempo de carregamento menor que 1 minuto", x = "Tamanho(em Mb)", y = "Tempo de carregamento( em s)") + 
  facet_grid(~dataset) + scale_color_hue(guide = FALSE)  +  theme(plot.title = element_text(size = 15, hjust = 0, vjust = 1, margin = margin(10,10,25,10)))

plot4<-
  ggplot(gdata %>% filter(time>60  & !error & dataset != "CENSO") , aes(x = size, y = time, color = key)) + 
  geom_point() + labs(title = "Desempenho das bases de dados com tempo de carregamento menor que 1 minuto", x = "Tamanho(em Mb)", y = "Tempo de carregamento( em s)") + 
  facet_grid(~dataset) + scale_color_hue(guide = FALSE)  +  theme(plot.title = element_text(size = 15, hjust = 0, vjust = 1, margin = margin(10,10,25,10)))


