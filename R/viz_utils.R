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


#' Create Static Occurrence Map
#' 
#' @param bounding_sf
#' @param points_sf
#' 
#' @importFrom ggplot2 ggplot geom_sf
#' 
#' @return A ggplot object.
#' @export
plot_occurrences_map <- function(state_sf, points_sf) {
  ggplot2::ggplot() +
    ggplot2::geom_sf(data = state_sf, fill = "gray95", color = "black") +
    ggplot2::geom_sf(data = points_sf,
                     color = "forestgreen",
                     alpha = 0.8) +
    ggplot2::theme_void()
}
