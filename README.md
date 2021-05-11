
# Fuzzy map buildings

INSPIRE is "an EU initiative to establish an infrastructure for spatial information in Europe that is geared to help to make spatial or geographical information more accessible and interoperable for a wide range of purposes supporting sustainable development".

Spanish cadastre INSPIRE page -> http://www.catastro.meh.es/webinspire/index.html

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

## Bibliography
- https://dominicroye.github.io/en/2019/visualize-urban-growth/
