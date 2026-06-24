#' Get GBIF Taxon Key
#'
#' Retrieves the GBIF usageKey (taxonKey) for a given taxonomic name
#' using the GBIF backbone taxonomy.
#'
#' @param taxon_name Character. A scientific name (e.g., "Cambaridae").
#'
#' @return Integer taxonKey used for GBIF queries.
#' @export
#'
#' @examples
#' get_taxon_key("Cambaridae")
get_taxon_key <- function(taxon_name) {
  rgbif::name_backbone(taxon_name)$usageKey
}


#' Query GBIF Occurrence Records
#'
#' Retrieves occurrence records from GBIF using rgbif::occ_search().
#' This function is designed for museum collection workflows and supports
#' filtering by geography, collection, and institution.
#'
#' @param taxon_key Integer. GBIF taxonKey.
#' @param state_gadm Character. GADM identifier (e.g., "USA.1_1" for Alabama).
#' @param collection_code Character. Collection code filter.
#' @param publishing_org Character. GBIF publishing organization UUID.
#' @param basis Character. Basis of record (default: "PRESERVED_SPECIMEN").
#' @param limit Integer. Maximum number of records to retrieve.
#'
#' @return A GBIF occurrence object from rgbif::occ_search().
#' @export
#'
#' @examples
#' \dontrun{
#' get_gbif_occurrences(taxon_key = 123, state_gadm = "USA.1_1")
#' }
get_gbif_occurrences <- function(taxon_key,
                                 state_gadm = NULL,
                                 collection_code = NULL,
                                 publishing_org = NULL,
                                 basis = "PRESERVED_SPECIMEN",
                                 limit = 2000) {
  
  rgbif::occ_search(
    taxonKey = taxon_key,
    gadmGid = state_gadm,
    collectionCode = collection_code,
    publishingOrg = publishing_org,
    basisOfRecord = basis,
    limit = limit
  )
}


#' Extract GBIF Occurrence Data
#'
#' Extracts the data slot from a GBIF occurrence object and returns
#' it as a tibble for downstream analysis.
#'
#' @param gbif_obj Output from get_gbif_occurrences().
#'
#' @return A tibble of occurrence records.
#' @export
extract_occurrence_data <- function(gbif_obj) {
  gbif_obj$data
}
