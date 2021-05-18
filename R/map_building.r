#' Using the information of cadastre, generate map with the building age information
#'

#' @export
#' @import tidyverse feedeR sf lubridate fs tmap classInt showtext sysfonts rvest
#' @examples create_spanish_cad_building_age("Salamanca")

create_spanish_cad_building_age <- function(city) {
    
    # load packages
    library(feedeR)
    library(sf) 
    library(fs)
    library(tidyverse)
    library(lubridate)
    library(classInt)
    library(tmap)
    library(rvest)

    url <- "http://www.catastro.minhap.es/INSPIRE/buildings/ES.SDGC.bu.atom.xml"

    # import RSS feed with provincial links
    prov_enlaces <- feed.extract(url)
    str(prov_enlaces)

    # extract the table with the links
    prov_enlaces_tab <- as_tibble(prov_enlaces$items) %>% 
                        mutate(title = repair_encoding(title))

    # filter the province and get the RSS link
    atom <- filter(prov_enlaces_tab, str_detect(title, city)) %>% pull(link)

    # import the RSS
    enlaces <- feed.extract(atom)

    # get the table with the download links
    enlaces_tab <- enlaces$items
    enlaces_tab <- mutate(enlaces_tab, title = repair_encoding(title), link = repair_encoding(link)) 

    pattern_city <- paste("-", toupper(city), sep="")

    link_city <- filter(enlaces_tab, str_detect(title, pattern_city)) %>% pull(link)

    # download the data
    download.file(link_city, temp <- tempfile(), method = "libcurl", quiet = TRUE, cacheOK = TRUE)

    # unzip to a folder called buildings
    unzip(temp, exdir = "buildings")

    # get the path with the file
    file_buildings <- dir_ls("buildings", regexp = "building.gml")

    # import the data
    buildings <- mutate(st_read(file_buildings), 
                beginning = str_replace(beginning, "^-", "0000") %>% 
                                ymd_hms() %>% as_date()
                )

    #font download
    sysfonts::font_add_google("Montserrat", "Montserrat")

    #use showtext for fonts
    showtext::showtext_auto()

    filter(buildings, beginning >= "1750-01-01")

    # get the coordinates of the city
    ciudad_point <- tmaptools::geocode_OSM(city, as.sf = TRUE)

    #  project the points
    ciudad_point <- st_transform(ciudad_point, 25830)

    # create the buffer
    point_bf <- st_buffer(ciudad_point, 2500)

    # get the intersection between the buffer and the building
    buildings_25 <- st_intersection(buildings, point_bf)

    # find 15 classes
    br <- classIntervals(year(buildings_25$beginning), 15, "quantile")

    # create labels
    lab <- names(print(br, under = "<", over = ">", cutlabels = FALSE))

    # categorize the year
    buildings_25 <- mutate(buildings_25, yr_cl = cut(year(beginning), br$brks, labels = lab, include.lowest = TRUE))

    # colours
    col_spec <- RColorBrewer::brewer.pal(11, "Spectral")

    # colour ramp function
    col_spec_fun <- colorRampPalette(col_spec)

    print("Creating building map")
    # create the map
    final_map <- tm_shape(buildings_25) +
        tm_polygons("yr_cl", 
                border.col = "transparent",
                palette = col_spec_fun(15),
                textNA = "Without data",
                title = "") +
        tm_layout(bg.color = "black",
            outer.bg.color = "black",
            legend.outside = TRUE,
            legend.text.color = "white",
            legend.text.fontfamily = "Montserrat", 
            legend.text.size = 1.7,
            panel.label.fontfamily = "Montserrat",
            panel.label.color = "white",
            panel.label.bg.color = "black",
            panel.label.size = 5,
            panel.label.fontface = "bold")

    print("Saving map")

    tmap_save(final_map, 
            filename = paste(city, "_evolution_urban.png", sep=""),
            scale = 1, 
            width = 2560,
            units = "px",
            dpi = 300)
    
    print("All done")

}

#' Using the information of bizkaia cadastre, generate map with the building age information
#'

#' @export
#' @import tidyverse feedeR sf lubridate fs tmap classInt showtext sysfonts rvest
#' @examples create_bizkaia_cad_building_age("Bilbao")

create_bizkaia_cad_building_age <- function(city) {
    library(feedeR)
    library(sf) 
    library(fs)
    library(tidyverse)
    library(lubridate)
    library(classInt)
    library(tmap)
    library(rvest)

    url <- "http://arcgis.bizkaia.eus:8080/inspire/buildings.xml"

    enlaces <- feed.extract(url)
    str(enlaces)

    enlaces_tab <- as_tibble(enlaces$items) %>% 
                       mutate(title = repair_encoding(title))

    url_city <- filter(enlaces_tab, str_detect(title, toupper(city))) %>% pull(link)
    
    # download the data
    download.file(url_city, temp <- tempfile(), method = "libcurl", quiet = TRUE, cacheOK = TRUE)

    # unzip to a folder called buildings
    unzip(temp, exdir = "buildings")

    # get the path with the file
    file_buildings <- dir_ls("buildings", regexp = "ES.BFA.BU.gml")

    # import the data
    buildings <- mutate(st_read(file_buildings), 
                beginning = str_replace(beginLifespanVersion, "^-", "0000") %>% 
                                ymd_hms() %>% as_date()
                )

    #font download
    sysfonts::font_add_google("Montserrat", "Montserrat")

    #use showtext for fon
    showtext::showtext_auto()

    filter(buildings, end >= "1750-01-01")

    # get the coordinates of the city
    ciudad_point <- tmaptools::geocode_OSM(city, as.sf = TRUE)

    #  project the points
    ciudad_point <- st_transform(ciudad_point, st_crs(buildings))

    # create the buffer
    point_bf <- st_buffer(ciudad_point, 3000)

    # get the intersection between the buffer and the building
    buildings_25 <- st_intersection(buildings, point_bf)

    # find 15 classes
    br <- classIntervals(year(buildings_25$end), 15, "quantile")

    # create labels
    lab <- names(print(br, under = "<", over = ">", cutlabels = FALSE))

    # categorize the year
    buildings_25 <- mutate(buildings_25, yr_cl = cut(year(end), br$brks, labels = lab, include.lowest = TRUE))

    # colours
    col_spec <- RColorBrewer::brewer.pal(11, "Spectral")

    # colour ramp function
    col_spec_fun <- colorRampPalette(col_spec)

    print("Creating building map")
    # create the map
    final_map <- tm_shape(buildings_25) +
        tm_polygons("yr_cl", 
                border.col = "transparent",
                palette = col_spec_fun(15),
                textNA = "Without data",
                title = "") +
        tm_layout(bg.color = "black",
            outer.bg.color = "black",
            legend.outside = TRUE,
            legend.text.color = "white",
            legend.text.fontfamily = "Montserrat", 
            legend.text.size = 1.5,
            panel.label.fontfamily = "Montserrat",
            panel.label.color = "white",
            panel.label.bg.color = "black",
            panel.label.size = 5,
            panel.label.fontface = "bold")

    print("Saving map")

    tmap_save(final_map, 
            filename = paste(city, "_evolution_urban.png", sep=""),
            scale = 1, 
            width = 2560,
            units = "px",
            dpi = 300)
    
    print("All done")
}