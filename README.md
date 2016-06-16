<!-- README.md is generated from README.Rmd. Please edit that file -->
microdadosBrasil
================

work in progress
----------------

### NEW:

-   Censo 2010
-   Don't know R? See: [using the package from Stata and Python](https://github.com/lucasmation/microdadosBrasil/blob/master/vignettes/Running_from_other_software.Rmd)

### COMMING SOON:

-   vignettes and Portuguese documentation
-   RAIS and CAGED (public versions) , PNAD\_Continua
-   Censo 1991, PNADs before 2001
-   Support for data not fitting into memory.

IN near the future:

-   variable name harmonization

Description
-----------

this package contains functions to read most commonly used Brazilian microdata easily and quickly. Importing Brazilian microdata can be tedious. Most data is provided in fixed width files (fwf) with import instructions only for SAS and SPSS. Data usually comes subdivided by state (UF) or macro regions (regiões). Also, filenames can vary, for the same dataset overtime. `microdadoBrasil` handles all these idiosyncrasies for you. In the background the package is running `readr` for fwf data and `data.table` for .csv data. Therefore reading is reasonably fast.

Currently the package includes import functions for:

| Source | Dataset                 | Import\_function            | Period       | Subdataset                |
|:-------|:------------------------|:----------------------------|:-------------|:--------------------------|
| IBGE   | PNAD                    | read\_PNAD                  | 2001 to 2014 | domicilios, pessoas       |
| IBGE   | Censo Demográfico       | read\_CENSO                 | 2000         | domicilios, pessoas       |
| IBGE   | POF                     | read\_POF                   | 2008         | several, see details      |
| INEP   | Censo Escolar           | read\_CensoEscolar          | 1995 to 2014 | escolas, ..., see detials |
| INEP   | Censo da Educ. Superior | read\_CensoEducacaoSuperior | 1995 to 2014 | see details               |

The package includes internally a list of import dictionaries for each dataset-subdataset-year. These were constructed with the `import_SASdictionary` function, which users can use to import dictionaries from datasets not included here. Import dictionaries for the datasets included in the package can be accessed with the `get_import_dictionary` function.

The package also harmonizes folder names, folder structure and file name that change overtime through a metadata table.It also unifies data that comes subdivides by regional subgroups (UF or região) into a single data file.

Installation
------------

``` r
install.packages("devtools")
install.packages("stringi") 
devtools::install_github("lucasmation/microdadosBrasil")
library('microdadosBrasil')
```

Usage
-----

``` r
# Censo Demográfico 2000
#after having downloaded the data to the root directory, and unziped to root run
d <- read_CENSO('domicilios',2000)
d <- read_CENSO('pessoas',2000)

# PNAD 2002
download_sourceData("PNAD", 2002, unzip = T)
d  <- read_PNAD("domicilios", 2002)
d2 <- read_PNAD("pessoas", 2002)

# Censo Escolar
download_sourceData('CensoEscolar', 2005, unzip=T)
d <- read_CensoEscolar('escola',2005)
d <- read_CensoEscolar('escola',2005,harmonize_varnames=T)
```

Related efforts
---------------

This package is highly influenced by similar efforts, which are great time savers, vastly used and often unrecognized:

-   Anthony Damico's [scripts to read most IBGE surveys](http://www.asdfree.com/). Great if you your data does not fit into memory and you want speed when working with complex survey design data.
-   [Data Zoom](http://www.econ.puc-rio.br/datazoom/) by Gustavo Gonzaga, Cláudio Ferraz and Juliano Assunção. Similar ease of use and harmonization of Brazilian microdada for Stata.
-   [dicionariosIBGE](https://cran.r-project.org/web/packages/dicionariosIBGE/index.html), by Alexandre Rademaker. A set of data.frames containing the information from SAS import dictionaries for IBGE datasets.
-   [IPUMS](https://international.ipums.org/international/). Harmonization of Census data from several countries, including Brasil. Import functions for R, Stata, SAS and SPSS.

`microdadosBrasil` differs from those packages in that it:

-   updates import functions to more recent years
-   includes non-IBGE data, such as INEP Education Census and MTE RAIS (de-identified)
-   separates import code from dataset specific metadata, as explained bellow.

How the package works
---------------------

### Traditional Import Workflow

Nowadays packages are normally provided on-line (or in a physical CD for the older IBGE publications) as .zip files with the following structure:

dataset\_year.zip

-   dataset\_year
    -   DICTIONARIES
        -   import\_dictionary\_subdatasetA.SAS
    -   DATA
        -   subdatasetA\_state1.txt
        -   subdatasetA\_state2.txt
        -   ...
        -   subdatasetA\_stateN.txt
    -   ADITIONAL DOCUMENTATION
        -   subdatasetA\_variables\_and\_cathegories\_dictionary.xls

Users then normally manually reconstruct the import dictionaries in R by hand. Then, using this dictionary, run the import function, pointing to the DATA folder. Larger datasets (such as CENSUS or RAIS) come subdivided by state (or region), so the function must be repeated for all states. Then if the user needs more than one year of the dataset, the user repeats all the above, adjuting for changes fine and folder names.

### microdadosBrasil aproach

(soon)

#### Design principles

The main design principle was separating details of each dataset in each year - such as folder structure, data files and import dictionaries of the of original data - into metadata tables (saved as csv files at the `extdata` folder). The elements in these tables, along with list of import dictionaries extracted from the SAS import instructions from the data provider, serve as parameters to import a dataset for a specific year. This separation of dataset specific details from the actual code makes code short and easier to extend to new packages.

ergonomics over speed (develop)
