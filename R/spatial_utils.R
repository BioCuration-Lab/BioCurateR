#' Convert Occurrence Data to sf Points
#'
#' Converts a data frame with longitude and latitude columns into
#' an sf object. Records missing coordinates are removed.
#'
#' @param df Data frame containing occurrence records.
#' @param lon Character. Longitude column name.
#' @param lat Character. Latitude column name.
#'
#' @return An sf object with point geometries.
#' @export
to_sf_points <- function(df,
                         lon = "decimalLongitude",
                         lat = "decimalLatitude") {
  
  df |>
    dplyr::filter(!is.na(.data[[lon]]), !is.na(.data[[lat]])) |>
    sf::st_as_sf(coords = c(lon, lat), crs = 4326)
}

#' Get State Boundary as sf Object
#'
#' Retrieves a U.S. state boundary from the maps package and converts
#' it into an sf object with WGS84 CRS.
#'
#' @param state_name Character. State name in lowercase (e.g., "alabama").
#'
#' @return An sf polygon object.
#' @export
get_state_boundary <- function(state_name) {
  maps::map("state", regions = state_name, fill = TRUE, plot = FALSE) |>
    sf::st_as_sf() |>
    sf::st_set_crs(4326)
}


#' Clip Point Coordinates to a Boundary 
#' 
#' @param input_sf
#' @param bounding_sf
#' 
#' @return An sf polygon object.
#' 
#' @export

clip_to_boundary <- function(input_sf, bounding_sf) {
  if (sf::st_crs(input_sf)[[1]] == sf::st_crs(bounding_sf)[[1]]) {
  sf::st_intersection(input_sf, bounding_sf)
} else
  message("CRS of 'bounding_sf' has been transformed to match 'input_sf'.")
  input_sf |>
    sf::st_transform(sf::st_crs(bounding_sf)) |>
    sf::st_intersection(bounding_sf)
}

#' Find HUC Layers
#' 
get_huc8 <- function(aoi) {
  nhdplusTools::get_huc(AOI = aoi, type = "huc08")
}
