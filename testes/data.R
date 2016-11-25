#' PNAD dictionaries
#'
#' A list containing IBGE dictionaries for PNAD from 2001 to 2014 translated into data frames.
#'
#' @format A list with 13 lists (one for each year), each one of these lists contains 2 data frames (one for each file type), each data frame is named 'dic_filetype_year'. The general data frame contains 9 variables and one observation for each variable of the dataset that is used to import:
#' \describe{
#'   \item{int_pos}{start position of the variable in each line}
#'   \item{var_name}{name of the variable}
#'   \item{label}{descriptive label for the variable, if available}
#'   \item{length}{length of the variable}
#'   \item{decimal_places}{number of decimal places of the variable}
#'   \item{fin_pos}{final position of the variable in each line}
#'   \item{col_types}{suggested column type of the variable. 'c' for character, 'i' for integer and 'd' for double}
#'   \item{CHAR}{dummy variable for character type, used to ease programming with}
#'   ...
#' }
#'
#' @examples \dontrun{ data(PNAD_dics)
#'
#' ## Acess pessoas dictionary for 2014:
#' PNAD_dics$`2014`$`dic_pessoas_2014`
#'
#' ## Alternatively, use the wrapper function
#' get_import_dictionary("PNAD", 2014, "pessoas")}
#'
#' @source \url{http://www.ibge.gov.br/home/estatistica/populacao/trabalhoerendimento/pnad2014/microdados.shtm}
"PNAD_dics"

#' Censo da Educação Superior dictionaries
#'
#' A list containing INEP import dictionaries for Censo da Educação Superior from 1995 to 2012 translated into data frames.
#'
#' @format A list with 18 lists (one for each year), each one of these lists contains 11 data frames (one for each file type), each data frame is named 'dic_filetype_year'. The general data frame contains 9 variables and one observation for each variable of the dataset that is used to import:
#' \describe{
#'   \item{int_pos}{start position of the variable in each line}
#'   \item{var_name}{name of the variable}
#'   \item{label}{descriptive label for the variable, if available}
#'   \item{length}{length of the variable}
#'   \item{decimal_places}{number of decimal places of the variable}
#'   \item{fin_pos}{final position of the variable in each line}
#'   \item{col_types}{suggested column type of the variable. 'c' for character, 'i' for integer and 'd' for double}
#'   \item{CHAR}{dummy variable for character type, used to ease programming with}
#'   ...
#' }
#'
#' @examples \dontrun{ data(CensoEducacaoSuperior_dics)
#'
#' ## Acess ies dictionary for 2010:
#' CensoEducacaoSuperior_dics$`2010`$`dic_ies_2010`
#'
#' ## Alternatively, use the wrapper function
#' get_import_dictionary("CensoEducacaoSuperior", 2010, "ies")}
#'
#' @source \url{http://portal.inep.gov.br/basica-levantamentos-acessar}


"CensoEducacaoSuperior_dics"

#' Censo Escolar dictionaries
#'
#' A list containing INEP import dictionaries for Censo da Educação Superior from 1995 to 2009 translated into data frames.
#'
#' @format A list with 15 lists (one for each year), each one of these lists contains 12 data frames (one for each file type), each data frame is named 'dic_filetype_year'. The general data frame contains 9 variables and one observation for each variable of the dataset that is used to import:
#' \describe{
#'   \item{int_pos}{start position of the variable in each line}
#'   \item{var_name}{name of the variable}
#'   \item{label}{descriptive label for the variable, if available}
#'   \item{length}{length of the variable}
#'   \item{decimal_places}{number of decimal places of the variable}
#'   \item{fin_pos}{final position of the variable in each line}
#'   \item{col_types}{suggested column type of the variable. 'c' for character, 'i' for integer and 'd' for double}
#'   \item{CHAR}{dummy variable for character type, used to ease programming with}
#'   ...
#' }
#'
#' @examples \dontrun{
#'
#' data(CensoEducacaoSuperior_dics)
#'
#' ## Acess escolas dictionary for 2010:
#' (CensoEscolar_dics$`2010`$`dic_escolas_2010`)
#'
#' ## Alternatively, use the wrapper function
#' get_import_dictionary("CensoEscolar", 2010, "escolas")}
#'
#' @source \url{http://portal.inep.gov.br/basica-levantamentos-acessar}
"CensoEscolar_dics"

#' Censo Demográfico dictionaries
#'
#' A list containing IBGE import dictionaries for Censo from 2000 translated into data frames.
#'
#' @format A list with 1 list (one for each year), each one of these lists contains 2 data frames (one for each file type), each data frame is named 'dic_filetype_year'. The general data frame contains 9 variables and one observation for each variable of the dataset that is used to import:
#' \describe{
#'   \item{int_pos}{start position of the variable in each line}
#'   \item{var_name}{name of the variable}
#'   \item{label}{descriptive label for the variable, if available}
#'   \item{length}{length of the variable}
#'   \item{decimal_places}{number of decimal places of the variable}
#'   \item{fin_pos}{final position of the variable in each line}
#'   \item{col_types}{suggested column type of the variable. 'c' for character, 'i' for integer and 'd' for double}
#'   \item{CHAR}{dummy variable for character type, used to ease programming with}
#'   ...
#' }
#'
#' @examples
#' \dontrun{
#'
#' data(CensoIBGE_dics)
#'
#' ## Acess escolas dictionary for 2000:
#' (CensoIBGE_dics$`2000`$`dic_pessoas_2000`)
#'
#' ## Alternatively, use the wrapper function
#' get_import_dictionary("CensoIBGE", 2000, "pessoas") }
#'
#' @source \url{http://www.ibge.gov.br/home/estatistica/populacao/censo2000/default_microdados.shtm}
"CensoIBGE_dics"

#' Pesquisa Mensal de Emprego dictionaries
#'
#' A list containing IBGE import dictionaries for PME from 2002.1 to 2015.2 translated into data frames.
#'
#'
#' @format A list with 1 list (one for each year), each one of these lists contains 2 data frames (one for each file type), each data frame is named 'dic_filetype_year'. The general data frame contains 9 variables and one observation for each variable of the dataset that is used to import:
#' \describe{
#'   \item{int_pos}{start position of the variable in each line}
#'   \item{var_name}{name of the variable}
#'   \item{label}{descriptive label for the variable, if available}
#'   \item{length}{length of the variable}
#'   \item{decimal_places}{number of decimal places of the variable}
#'   \item{fin_pos}{final position of the variable in each line}
#'   \item{col_types}{suggested column type of the variable. 'c' for character, 'i' for integer and 'd' for double}
#'   \item{CHAR}{dummy variable for character type, used to ease programming with}
#'   ...
#' }
#'
#' @examples \dontrun{ data(PME_dics)
#'
#' ## Acess escolas dictionary for 2000:
#' (PME_dics$`2012.1`$`dic_PME_2012.1`)
#'
#' ## Alternatively, use the wrapper function
#' get_import_dictionary("PME", 2012.1, "PME")}
#'
#' @source \url{http://www.ibge.gov.br/home/estatistica/indicadores/trabalhoerendimento/pme_nova/defaultmicro.shtm}
"PME_dics"

#' PNAD continua dictionaries
#'
#' A list containing IBGE import dictionaries for PNAD Continua from 2012.1 to 2016.1 translated into data frames.
#'
#' @format A list with 17 lists (one for each year), each one of these lists contains 1 data frame (one for each file type), each data frame is named 'dic_filetype_year'. The general data frame contains 9 variables and one observation for each variable of the dataset that is used to import:
#' \describe{
#'   \item{int_pos}{start position of the variable in each line}
#'   \item{var_name}{name of the variable}
#'   \item{label}{descriptive label for the variable, if available}
#'   \item{length}{length of the variable}
#'   \item{decimal_places}{number of decimal places of the variable}
#'   \item{fin_pos}{final position of the variable in each line}
#'   \item{col_types}{suggested column type of the variable. 'c' for character, 'i' for integer and 'd' for double}
#'   \item{CHAR}{dummy variable for character type, used to ease programming with}
#'   ...
#' }
#'
#' @examples \dontrun{ data(PNADcontinua_dics)
#'
#' ## Acess pessoas dictionary for 2012.1:
#' (PNADcontinua_dics$`2012.1`$`dic_pessoas_2012.1`)
#'
#' ## Alternatively, use the wrapper function
#' get_import_dictionary("PNADcontinua", "2012.1", "pessoas")}
#'
#' @source \url{http://www.ibge.gov.br/home/estatistica/indicadores/trabalhoerendimento/pnad_continua/default_microdados.shtm}
"PNADcontinua_dics"

#' Pesquisa de Orçamentos Familiares dictionaries
#'
#' A list containing IBGE import dictionaries for POF from 2008/2009 translated into data frames.
#'
#' @format A list with 1 list (one for each year), each one of these lists contains 16 data frame (one for each file type), each data frame is named 'dic_filetype_year'. The general data frame contains 9 variables and one observation for each variable of the dataset that is used to import:
#' \describe{
#'   \item{int_pos}{start position of the variable in each line}
#'   \item{var_name}{name of the variable}
#'   \item{label}{descriptive label for the variable, if available}
#'   \item{length}{length of the variable}
#'   \item{decimal_places}{number of decimal places of the variable}
#'   \item{fin_pos}{final position of the variable in each line}
#'   \item{col_types}{suggested column type of the variable. 'c' for character, 'i' for integer and 'd' for double}
#'   \item{CHAR}{dummy variable for character type, used to ease programming with}
#'   ...
#' }
#'
#' @examples \dontrun{ data(POF_dics)
#'
#' ## Acess T_DESPESA_90DIAS_S dictionary for 2008:
#' (POF_dics$`2008`$`dic_T_DESPESA_90DIAS_S_2008`)
#'
#' ## Alternatively, use the wrapper function
#' get_import_dictionary("POF", "2008", "T_DESPESA_90DIAS_S") }
#'
#' @source \url{http://www.ibge.gov.br/home/estatistica/populacao/condicaodevida/pof/2008_2009/microdados.shtm}
"POF_dics"

