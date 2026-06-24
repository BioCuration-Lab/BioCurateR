#' Lookup GADM GID for a State (Admin Level 1)
#'
#' Retrieves the GADM (Global Administrative Areas) identifier (`GID_1`)
#' for a U.S. state (or equivalent administrative unit) by name.
#' The function downloads GADM level 1 data using \pkg{geodata},
#' converts it to a tibble with \pkg{tidyterra}, and filters
#' for the matching state name.
#'
#' @param state_name Character. Name of the state to search for
#'   (case-insensitive, will be converted to sentence case).
#' @param country Character. ISO or GADM country code.
#'   Defaults to `"USA"`.
#'
#' @return A character vector containing the matching `GID_1` value(s).
#'   Returns `NULL` or an empty vector if no match is found.
#'
#' @details
#' This function standardizes the input state name using
#' \code{stringr::str_to_sentence()} before matching against
#' the `NAME_1` column in GADM data.
#'
#' The GADM dataset is downloaded to a temporary directory via
#' \code{tempdir()} on each call.
#'
#' @examples
#' state_gid <- lookup_state_gadm(state_name = "alabama")
#'
#' @importFrom geodata gadm
#' @importFrom tidyterra as_tibble
#' @importFrom dplyr filter pull
#' @importFrom stringr str_to_sentence
#'
#' @export
lookup_state_gadm <- function(state_name, country = "USA") {
  if (missing(state_name)) {
    stop("Argument 'state_name' must be provided.")
  }
  
  search_state <- stringr::str_to_sentence(state_name)
  
  gadm_tbl <- geodata::gadm(country = country,
                       level = 1,
                       path = tempdir()) %>%
    tidyterra::as_tibble() 
  
  matches <- gadm_tbl %>%
    filter(NAME_1 == search_state)
  
  
  validate_gadm_match(
    matches = matches,
    search_term = state_name,
    field = "state_name",
    choices = unique(gadm_tbl$NAME_1),
    level = "state"
  )
  
  gid <- matches %>% pull(GID_1)
  
  return(gid)
}



#' Lookup GADM GID for a County (Admin Level 2)
#'
#' Retrieves the GADM (Global Administrative Areas) identifier (`GID_2`)
#' for a county (or equivalent administrative unit) given a county
#' and state name. The function downloads GADM level 2 data using
#' \pkg{geodata}, converts it to a tibble with \pkg{tidyterra}, and
#' filters for the matching state and county.
#'
#' @param county_name Character. Name of the county to search for
#'   (case-insensitive, will be converted to sentence case).
#' @param state_name Character. Name of the state containing the county
#'   (case-insensitive, will be converted to sentence case).
#' @param country Character. ISO or GADM country code.
#'   Defaults to `"USA"`.
#'
#' @return A character vector containing the matching `GID_2` value(s).
#'   Returns `NULL` or an empty vector if no match is found.
#'
#' @details
#' Both `state_name` and `county_name` are standardized using
#' \code{stringr::str_to_sentence()} before matching against
#' `NAME_1` (state) and `NAME_2` (county) fields in GADM data.
#'
#' The GADM dataset is downloaded to a temporary directory via
#' \code{tempdir()} on each call.
#'
#' @examples
#' county_gid <- lookup_county_gadm(county_name = "Lee",
#'                                 state_name = "Alabama")
#'
#' @importFrom geodata gadm
#' @importFrom tidyterra as_tibble
#' @importFrom dplyr filter pull
#' @importFrom stringr str_to_sentence
#'
#' @export
lookup_county_gadm <- function(county_name, state_name, country = "USA") {
  if (missing(state_name) || missing(county_name)) {
    stop("Arguments 'county_name' and 'state_name' must be provided.")
  }
  
  search_state <- stringr::str_to_sentence(state_name)
  search_county <- stringr::str_to_sentence(county_name)
  
  gadm_tbl <- geodata::gadm(country = country,
                       level = 2,
                       path = tempdir()) %>%
    tidyterra::as_tibble()
  
  matches <- gadm_tbl %>%
    filter(NAME_1 == search_state & 
             NAME_2 == search_county) 
  
  
  state_subset <- gadm_tbl %>%
    filter(NAME_1 == search_state)
  
  validate_gadm_match(
    matches = matches,
    search_term = county_name,
    field = "county_name",
    parent_term = state_name,
    parent_field = "state_name",
    choices = unique(state_subset$NAME_2),
    level = "county"
  )
  
  gid <- matches %>% pull(GID_2)
  return(gid)
}

#' Validate GADM match results and provide user-friendly feedback
#'
#' Internal helper used to check match results from GADM lookups.
#' Throws informative errors when no matches are found and warns
#' when multiple matches exist.
#'
#' @param matches A tibble/data.frame of filtered GADM results.
#' @param search_term Character. The original user input (e.g., "alabama").
#' @param field Character. The field being searched (e.g., "state_name").
#' @param parent_term Character. Optional higher-level geography
#'   (e.g., state when searching for counties).
#' @param parent_field Character. Name of the parent field
#'   (e.g., "state_name").
#' @param choices Optional character vector of valid values to suggest.
#' @param level Character. GADM level label for messaging
#'   (e.g., "state", "county").
#'
#' @return Invisibly returns `matches` if valid.
#' @keywords internal
validate_gadm_match <- function(matches,
                                search_term,
                                field,
                                parent_term = NULL,
                                parent_field = NULL,
                                choices = NULL,
                                level = "region") {
  
  if (nrow(matches) == 0) {
    
    if (!is.null(parent_term) && !is.null(parent_field)) {
      
      # Case: parent exists but child does not (e.g., county in state)
      if (!is.null(choices) && length(choices) > 0) {
        stop(
          paste0(
            "No match found for ", field, " = '", search_term,
            "' in ", parent_field, " = '", parent_term, "'.\n",
            "Example valid ", level, "(s) include: ",
            paste(head(choices, 5), collapse = ", "), ", ..."
          ),
          call. = FALSE
        )
      } else {
        stop(
          paste0(
            "No match found for ", parent_field, " = '", parent_term, "'.\n",
            "Check spelling or try a different country."
          ),
          call. = FALSE
        )
      }
      
    } else {
      
      # Case: top-level (state)
      if (!is.null(choices) && length(choices) > 0) {
        stop(
          paste0(
            "No match found for ", field, " = '", search_term, "'.\n \n",
            "Example valid ", level, "s include: ",
            paste(head(choices, 5), collapse = ", "), ", ..."
          ),
          call. = FALSE
        )
      } else {
        stop(
          paste0(
            "No match found for ", field, " = '", search_term, "'."
          ),
          call. = FALSE
        )
      }
    }
  }
  
  if (nrow(matches) > 1) {
    warning(
      paste0(
        "Multiple matches found for ", field, " = '", search_term, "'. ",
        "Returning all matches. Verify this is expected."
      ),
      call. = FALSE
    )
  }
  
  return(invisible(matches))
}
