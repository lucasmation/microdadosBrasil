# install.packages("RPostgreSQL")
library("RPostgreSQL")
library(dplyr)
pass<- "*****"

teste_iris<- iris

#Cria base iris empilhada


for(i in 1:101){

  teste_iris<-bind_rows(teste_iris,teste_iris)

}

drv<- PostgreSQL()

conn = dbConnect(drv, dbname = "ninsoc",
                 host = "sbsb4d-postgis", port = 5432,
                 user = "b2826073",
                 password= pass)

t0 <- Sys.time()
dbWriteTable(conn,
             name=c("public", "teste_iris"),  # nome composto c(SCHEMA, TABELA)
             value=data.frame(teste_iris2),
             row.names=FALSE)
dbDisconnect(conn)
t1 <- Sys.time()
t1-t0 # tempo....


