
# Fuzzy map buildings

INSPIRE is an EU initiative to establish an infrastructure for spatial information in Europe that is geared to help to make spatial or geographical information more accessible and interoperable for a wide range of purposes supporting sustainable development.

Spanish cadastre INSPIRE page -> http://www.catastro.meh.es/webinspire/index.html  
Bizkaia cadastre INSPIRE page -> https://web.bizkaia.eus/es/inspirebizkaia

## Gradle Plugin (https://github.com/umayrh/gradle-plugin-r)
```
R setup, build and packaging tasks
----------------------------------
document - Creates documentation for R package
installDeps - Installs common packaging dependencies
packageBuild - Builds an R package into a tarball
packageCheck - Runs checks for an R package
packageClean
packratClean - Removes packages (compiled and sources) managed by Packrat for an R package
packratRestore - Restores packages managed by Packrat for R package
renvClean - Removes packages (compiled and sources) managed by Renv for an R package
renvRestore - Restores packages managed by Renv for R package
restore - Restores all dependencies for a package.
setup - Sets up a skeleton R package (warning: non-idempotent task).
setupCreate - Ensures that pre-conditions for package setup are satisfied.
setupPackrat - Sets up a skeleton R package using Renv (warning: non-idempotent task).
setupRenv - Sets up a skeleton R package using Renv (warning: non-idempotent task)
test - Runs test for an R package
```

## Some dependencies
- [gcc-fortrand](https://gcc.gnu.org/fortran/index.html)
- [libudunits2](https://www.unidata.ucar.edu/software/udunits/udunits-2.0.4/)
- [gdal-config](https://gdal.org/programs/gdal-config.html)

## Installation
You can install the released version of fuzzymapbuildings from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("fuzzymapbuildings")
```
or
```R
devtools::install_github("vjsantojaca/fuzzy-map-buildings")
```

## Example
``` r
library(fuzzymapbuildings)

create_spanish_cad_building_age("Salamanca")
```
or
```r
library(fuzzymapbuildings)

create_bizkaia_cad_building_age("Bilbao")
```
## Result

### Salamanca
![Salamanca](misc/Salamanca_evolution_urban.png "Salamanca")
### Bilbao
![Bilbao](misc/Bilbao_evolution_urban.png "Bilbao")

## Collaborate
You could download this code, modify it and share with the family 🤌🤌  
If you see that any part of the code could be improved (you are surely right), please open a new ticket in this repo or upload a new Pull Request 🤓🤓  
I would appreciate it infinitely.

## Bibliography
- https://dominicroye.github.io/en/2019/visualize-urban-growth/
