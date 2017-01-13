<!-- README.md is generated from README.Rmd. Please edit that file -->
Section about GitHub/Git/Devtools usage:
----------------------------------------

Inserting a new dataset in the package:
---------------------------------------

Note: for hereon *dataset* stands as an alias for the name of the dataset you are trying to insert on the package, *filetype* as an alias to the subgroups inside each dataset( for PNAD we have the filetypes *pessoas*(*persons*) and *famílias*(*households*)) and *period* as an alias to every period available for that dataset and filetype.

Each new dataset depends on four pieces:

-   One folder inside `inst/extdata` with the name of the dataset and one subfolder named `dictionaries`
-   One file with metadata inside the folder you created with the name `dataset_files_metadata_harmonization.csv`
-   One wrapper function defined on the file `R/import_wrapper_functions.R`
-   Dictionaries stored inside `dataset/dictionaries` with the name `import_dictionary_dataset_filetype_period.csv`.

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

1.  Create one column for each *file type*(if you used a template from another dataset, also remove the old ones) of the dataset, this columns should be named `ft_filetype`( remember, here *filetype* is just an alias!).

2.  Fill the other columns, for each period:

-   format: csv if the dataset is a delimited file( even if is stored in other actual format, as .txt). `fwf` if the dataset is fixed width format file( in this case a dictionary will be needed)
-   download\_path: The path of the download, can be a direct link from a zipped folder or a path to a ftp folder.
-   download\_mode: `ftp` for ftp folders and `source` for a direct link
-   missing\_symbols: comma separated vector with possible missing values of the dataset. NA if none.
-   path: The name of the main folder, exactly as downloaded from the source( Ex: PNAD\_1401)
-   inputs\_folder: Inside that folder should be a folder with the dictionaries stored in .txt on .sas format. Keep blank if there is no such folder.
-   data\_folder: Inside the main folder should be a folder with the data stored. Keep blank if there is no such folder( speacially if the data is stored inside the main folder).
-   ft\_\* : this columns are a little tricky, you may have noted that the content of it is in the format `A&B`. `A` should be the name of the Input dictionary for that filetype in the case of fwf datasets or the delimiter in the case of delimited files. `B` should be the name of the file for that specific dataset, it can also be a regular expression for multiple files( in this case the data of the multiple files will be pooled.)

Once you have done all that, you can check if is everything working using the functions: `read_metadata` , `get_available_datasets`, `get_available_periods` and `get_available_filetypes`.

### 2. The wrapper function:

### 3. Dictionaries:
