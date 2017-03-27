<!-- README.md is generated from README.Rmd. Please edit that file -->
The toolbox:
------------

Everyone is allowed to contribute to this package or modify it for own use. If you want to do it, it will be easier if you use the same tools that we use, we suggest( but is certainly possible to do without it) that before trying, you do :

-   Install GIT
-   Fork the repository and set it up on RStudio
-   Learn the basics about packages structure in R

Design principles
-----------------

The main design principle was separating details of each dataset in each year - such as folder structure, data files and import dictionaries of the of original data - into metadata tables (saved as csv files at the `extdata` folder). The elements in these tables, along with list of import dictionaries extracted from the SAS import instructions from the data provider, serve as parameters to import a dataset for a specific year. This separation of dataset specific details from the actual code makes code short and easier to extend to new packages.

Inserting a new dataset in the package:
---------------------------------------

Note: for hereon **dt** stands as an alias for the name of the dataset you are trying to insert on the package, **ft** as an alias to the subgroups( we will also refer to them as 'file\_type') inside each dataset( for PNAD we have the file types *pessoas*(*persons*) and *famílias*(*households*)) and *period* as an alias to every period available for that dataset and filetype.

Each new dataset depends on four pieces:

-   One folder inside `inst/extdata` with the name of the dataset and one subfolder named `dictionaries`
-   One file with metadata, stored inside the folder you created, with the name `dt_files_metadata_harmonization.csv`
-   One wrapper function defined on the file `R/import_wrapper_functions.R`
-   Dictionaries stored inside `inst/extdata/dt/dictionaries` with the name `import_dictionary_dt_ft_period.csv`.

The first piece is clear, look at the folders already created for the other datasets if you have any doubt.Now we start with detailed instructions for the next steps.

### 1. The metadata file

This file stores information about the directory structure, download links, delimiters, and other general information. Using this kind of file allows to separate dataset specific information of the actual code. We suggest that you copy a ready metadata file ( as "PNAD\_metadata\_files\_harmonization.csv" ) and edit it to your needs. The file will be somewhat like this:

<table>
<colgroup>
<col width="2%" />
<col width="2%" />
<col width="48%" />
<col width="4%" />
<col width="5%" />
<col width="10%" />
<col width="4%" />
<col width="3%" />
<col width="9%" />
<col width="9%" />
</colgroup>
<thead>
<tr class="header">
<th align="right">period</th>
<th align="left">format</th>
<th align="left">download_path</th>
<th align="left">download_mode</th>
<th align="left">missing_symbols</th>
<th align="left">path</th>
<th align="left">inputs_folder</th>
<th align="left">data_folder</th>
<th align="left">ft_domicilios</th>
<th align="left">ft_pessoas</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="right">2001</td>
<td align="left">fwf</td>
<td align="left"><a href="ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/reponderacao_2001_2012/PNAD_reponderado_2001.zip" class="uri">ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/reponderacao_2001_2012/PNAD_reponderado_2001.zip</a></td>
<td align="left">source</td>
<td align="left">NA</td>
<td align="left">PNAD_reponderado_2001/2001</td>
<td align="left">Input</td>
<td align="left">Dados</td>
<td align="left">INPUT DOM2001.txt&amp;DOM2001.txt</td>
<td align="left">INPUT PES2001.txt&amp;PES2001.txt</td>
</tr>
<tr class="even">
<td align="right">2002</td>
<td align="left">fwf</td>
<td align="left"><a href="ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/reponderacao_2001_2012/PNAD_reponderado_2002.zip" class="uri">ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/reponderacao_2001_2012/PNAD_reponderado_2002.zip</a></td>
<td align="left">source</td>
<td align="left">NA</td>
<td align="left">PNAD_reponderado_2002/2002</td>
<td align="left">Input</td>
<td align="left">Dados</td>
<td align="left">INPUT DOM2002.txt&amp;DOM2002.txt</td>
<td align="left">INPUT PES2002.txt&amp;PES2002.txt</td>
</tr>
<tr class="odd">
<td align="right">2003</td>
<td align="left">fwf</td>
<td align="left"><a href="ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/reponderacao_2001_2012/PNAD_reponderado_2003_20150814.zip" class="uri">ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/reponderacao_2001_2012/PNAD_reponderado_2003_20150814.zip</a></td>
<td align="left">source</td>
<td align="left">NA</td>
<td align="left">PNAD_reponderado_2003_20150814/2003</td>
<td align="left">Input</td>
<td align="left">Dados</td>
<td align="left">INPUT DOM2003.txt&amp;DOM2003.txt</td>
<td align="left">INPUT PES2003.txt&amp;PES2003.txt</td>
</tr>
<tr class="even">
<td align="right">2004</td>
<td align="left">fwf</td>
<td align="left"><a href="ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/reponderacao_2001_2012/PNAD_reponderado_2004.zip" class="uri">ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/reponderacao_2001_2012/PNAD_reponderado_2004.zip</a></td>
<td align="left">source</td>
<td align="left">NA</td>
<td align="left">PNAD_reponderado_2004/2004</td>
<td align="left">Input</td>
<td align="left">Dados</td>
<td align="left">Input_Dom2004.txt&amp;DOM2004.txt</td>
<td align="left">Input_Pes2004.txt&amp;PES2004.txt</td>
</tr>
<tr class="odd">
<td align="right">2005</td>
<td align="left">fwf</td>
<td align="left"><a href="ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/reponderacao_2001_2012/PNAD_reponderado_2005.zip" class="uri">ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/reponderacao_2001_2012/PNAD_reponderado_2005.zip</a></td>
<td align="left">source</td>
<td align="left">NA</td>
<td align="left">PNAD_reponderado_2005/2005</td>
<td align="left">Input</td>
<td align="left">Dados</td>
<td align="left">Input Dom2005.txt&amp;DOM2005.txt</td>
<td align="left">Input Pes2005.txt&amp;PES2005.txt</td>
</tr>
<tr class="even">
<td align="right">2006</td>
<td align="left">fwf</td>
<td align="left"><a href="ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/reponderacao_2001_2012/PNAD_reponderado_2006.zip" class="uri">ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/reponderacao_2001_2012/PNAD_reponderado_2006.zip</a></td>
<td align="left">source</td>
<td align="left">NA</td>
<td align="left">PNAD_reponderado_2006/2006</td>
<td align="left">Input</td>
<td align="left">Dados</td>
<td align="left">Input Dom2006.txt&amp;DOM2006.txt</td>
<td align="left">Input Pes2006.txt&amp;PES2006.txt</td>
</tr>
</tbody>
</table>

The suggested order of editions is:

1.  Edit/create the period column with the available time periods of the dataset.
2.  If you used an template, clean the content of all cells of the table, except for the ones of the period column. If you didn't, create the columns:

-   format
-   download\_path
-   download\_mode
-   missing\_symbols
-   path
-   inputs\_folder
-   data\_folder

1.  Create one column for each *file type*(if you used a template from another dataset, also remove the old ones) of the dataset, this columns should be named `ft_ft`( Here, the first **ft** is literal and the second is just an alias for each file\_type).

2.  Fill the other columns, for each period:

-   format: csv if the dataset is a delimited file( even if is stored in other actual format, as .txt). `fwf` if the dataset is fixed width format file( in this case a dictionary will be needed)
-   download\_path: The path of the download, can be a direct link from a zipped folder or a path to a ftp folder.
-   download\_mode: `ftp` for ftp folders and `source` for a direct link
-   missing\_symbols: comma separated vector with possible missing values of the dataset. NA if none.
-   path: The name of the main folder, exactly as downloaded from the source( Ex: PNAD\_1401)
-   inputs\_folder: Inside that folder should be a folder with the dictionaries stored in .txt on .sas format. Keep blank if there is no such folder.
-   data\_folder: Inside the main folder should be a folder with the data stored. Keep blank if there is no such folder( speacially if the data is stored inside the main folder).
-   ft\_ft : this columns are a little tricky, you may have noted that the content of it is in the format `A&B`. `A` should be the name of the Input dictionary for that filetype in the case of fwf datasets or the delimiter in the case of delimited files. `B` should be the name of the file for that specific dataset, it can also be a regular expression for multiple files( in this case the data of the multiple files will be pooled.)

Once you have done all that, you can check if everything is working using the functions: `read_metadata` , `get_available_datasets`, `get_available_periods` and `get_available_filetypes`. See the help pages of each function for detail.

### 2. The wrapper function:

Each dataset has a wrapper function named `read_*`. The purpose of this function is only to call the main import function `read_data` with the appropriate arguments. This also allows for space to insert dataset-specific modifications. The wrapper function for the generic case should be:

``` r

#' @rdname read_dataset
#' @export
read_*<- function(ft,i,root_path=NULL,file = NULL, vars_subset = NULL){


  data<-read_*(dataset = "*", ft, i, root_path =  root_path, file = file, vars_subset = vars_subset)

  return(data)
}
```

Where `read_data` is the main internal function of the package, that does all the heavy work. The first two lines ( that starts with \#') are just commands to the roxygen package specifying the associated documentation of the function and that it should be exported(just keep that as it is) .

Copy the template and substitute the \* with the name of the dataset.

You can also insert dataset-specific modifications, look at the example of *CENSO* where we inserted an option(UF) to read only part of the files, based on the region of it ( using the name pattern):

``` r

#' @rdname read_dataset
#' @export
read_CENSO<- function(ft,i,root_path = NULL, file = NULL, vars_subset = NULL, UF = NULL){

  metadata <-  read_metadata('CENSO')

  if(is.null(file)){
  root_path<- ifelse(is.null(UF),
                     root_path,
                     paste0(ifelse(is.null(root_path),getwd(),root_path),"/",UF))
  if(!file.exists(root_path)){
    stop("Data not found, check if you provided a valid root_path or stored the data in your current working directory.")
  }
  }



  data<-read_data(dataset = "CENSO", ft = ft,i = i, root_path = root_path,file = file, vars_subset = vars_subset)


  return(data)
}
```

### 3. Dictionaries:

Dictionaries are stored as .csv tables in the \*/dictionaries folder, they are always named on the format "import\_dictionary\_\*\_\*\*\_period.csv" . The full path of the dictionary for the *pessoas* file of PNAD 2014 is `inst/extdata/PNAD/dictionaries/import_dictionary_PNAD_pessoas_2014.csv` ( you can check that on <https://github.com/lucasmation/microdadosBrasil> ).

The dictionaries contains the columns:

-   int\_pos: the start position of the variable
-   var\_name: the name of the variable
-   x: the SAS code that was used as input in case the dictionary wase created by `parses_SAS_import_dic()` ( you do not need to fill this, it was left here just for debugging reasons)
-   CHAR: TRUE if the variable is character, FALSE if is not
-   label: A description of the variable, it is not used in data importing, but can be helpful ( it may be easir to view the label in R using the package that looking at an excel table)
-   length: lenght of the variable
-   decimal\_places: length of decimal places ( NA if the variable is not numeric)
-   fin\_pos: final position at the line
-   col\_type: `c` for character, `i` for integer, `d` for numeric.

You can always see the dictionary from R using the function `get_import_dictionary`. The function `parses_SAS_import_dic` can be used to create the table using a SAS dictionary ( it uses regular expressions to try to translate the dictionary and can get wrong results sometimes, use at your own risk and look carefully at the results)
