<!-- README.md is generated from README.Rmd. Please edit that file -->
microadadosBrasil
=================

this package contains functions to read most commonly used Brazilian microdata easily and quickly. Importing Brazilian microdata can be tedious. Most data is provided in fixed width files (fwf) with import instructions only for SAS and SPSS. Data usually comes subdivided by state (UF) or macroregions (regiões). And filenames can vary, for the same dataset overtime. microdadoBrasil handles all these indissioncrasies for you. In the background the package is running readr for fwf data and data.table for .csv data. Therefore reading is reasonably fast.

Currently the package includes import functions for:

-   CENSO DEMOGRÁFICO: 2000 (soon to be expanded to 2010 and 1991)
-   POF
-   CENSO ESCOLAR, all years
-   CENSO DA EDUCAÇÃO SUPERIOR, all years

To be added soon:

-   RAIS, deidentified version,
-   download functions
-   variable name hamonization
-   Support for data not fiting into memory.

Installation
------------

``` r
# install.packages("devtools")
devtools::install_github("lucasmation/microdadosBrasil")
library('microdadosBrasil')
```

Usage
-----

``` r
#Censo Demográfico 2000
#after having downloaded the data to the root directory, and unziped to root run
d <- read_CensoEscolar('escola',2005)


# Censo Escolar
#download_CensoEscolar(2005) . Not yet available. In the future will download and unzip ( .rar files still need manual descompactation)
d <- read_CensoEscolar('escola',2005)
```

Design principle
----------------

The main design principle was separating details of each dataset in each year - such as folder structure, data files and import dictionaries of the of original data - into metadata tables (saved as csv files at the extdata folder). The elements in these tables, along with list of import dicionaries extracted from the SAS import instructions from the data provider, serve as parameters to import a dataset for a specific year. This separation of dataset specific details from the actual code makes code short and easier to extend to new packages.
