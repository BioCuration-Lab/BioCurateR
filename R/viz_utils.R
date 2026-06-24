#' Create Leaflet Map of Occurrence Records
#'
#' Generates an interactive Leaflet map with clustered occurrence points.
#'
#' @param df Data frame containing GBIF occurrence data.
#'
#' @return A leaflet map widget.
#' @export
make_leaflet_map <- function(df) {
  
  leaflet::leaflet(df) |>
    leaflet::addProviderTiles(leaflet::providers$Esri.NatGeoWorldMap) |>
    leaflet::addMarkers(
      lng = ~decimalLongitude,
      lat = ~decimalLatitude,
      popup = ~paste0(
        htmltools::htmlEscape(
          paste(institutionCode, collectionCode, catalogNumber, sep = ":")
        ),
        "<br>",
        htmltools::htmlEscape(scientificName)
      ),
      clusterOptions = leaflet::markerClusterOptions()
    )
}

