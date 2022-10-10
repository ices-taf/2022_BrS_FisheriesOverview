library(icesTAF)
library(icesFO)

areas <- load_areas("Barents Sea")

sf::st_write(areas, "areas.csv", layer_options = "GEOMETRY=AS_WKT")
