#' Get Boundary
#'
#' This function retrieves the appropriate boundary based on the specified type and name.
#' It uses the pre-loaded boundary datasets created from tidycensus data.
#'
#' @param boundary_type Character string. One of "state", "county", "msa", "tract", "block", or "dews".
#' @param boundary_name Character string. Name of the boundary (e.g., state name, county name, MSA name).
#'
#' @return An sf object representing the requested boundary.
#' @export
#'
#' @examples
#' \dontrun{
#' nc_boundary <- nclimgrid::get_boundary("state", "North Carolina")
#' wake_county <- nclimgrid::get_boundary("county", "Wake County")
#' }
get_boundary <- function(boundary_type, boundary_name) {
  switch(boundary_type,
         "state" = nclimgrid::us_states |>
           dplyr::filter(NAME == boundary_name),
         "county" = nclimgrid::us_counties |>
           dplyr::filter(NAME == boundary_name),
         "msa" = nclimgrid::census_msas |>
           dplyr::filter(NAME == boundary_name),
         "tract" = nclimgrid::census_tracts |>
           dplyr::filter(NAME == boundary_name),
         "block" = nclimgrid::census_blocks |>
           dplyr::filter(GEOID == boundary_name),
         "dews" = nclimgrid::nidis_dews |>
           dplyr::filter(NAME == boundary_name),
         stop("Invalid boundary_type. Must be one of: state, county, msa, tract, block, or dews")
  )
}
