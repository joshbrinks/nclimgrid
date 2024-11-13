#' Create NIDIS DEWS Boundaries
#'
#' This function creates an sf object of NIDIS Drought Early Warning System (DEWS) boundaries
#' by combining state boundaries and river basin components where necessary.
#'
#' @param us_states sf object of US states from tidycensus
#' @param missouri_basin sf object of Missouri River Basin from USGS WBD
#' @param pnw_basins sf object of Pacific Northwest river basins from USGS WBD
#' @param dews_regions list of DEWS regions and their component states
#' @param extended logical. If TRUE, includes extended regions (marked with *). Default FALSE.
#' @return sf object containing DEWS boundaries with names and geometries
create_dews_boundaries <- function(us_states, missouri_basin, pnw_basins, dews_regions,
                                   extended = FALSE) {

  # Transform all inputs to EPSG:4326
  us_states <- sf::st_transform(us_states, 4326)
  missouri_basin <- sf::st_transform(missouri_basin, 4326)
  pnw_basins <- sf::st_transform(pnw_basins, 4326)

  # Print CRS of inputs for verification
  message("CRS Check:")
  message("US States CRS: ", sf::st_crs(us_states)$input)
  message("Missouri Basin CRS: ", sf::st_crs(missouri_basin)$input)
  message("PNW Basins CRS: ", sf::st_crs(pnw_basins)$input)

  # Initialize empty list to store DEWS geometries
  dews_geometries <- list()

  # Filter regions based on extended parameter
  regions_to_process <- if (extended) {
    dews_regions
  } else {
    core_regions <- c(
      "California-Nevada",
      "Midwest",
      "Northeast",
      "Pacific Northwest",
      "Southeast",
      "Southern Plains",
      "Intermountain West",
      "Missouri River Basin"
    )
    dews_regions[names(dews_regions) %in% core_regions]
  }

  # Process each DEWS region
  for (dews_name in names(regions_to_process)) {
    message("Processing region: ", dews_name)

    # Get states for this DEWS
    states <- regions_to_process[[dews_name]]

    # Filter state geometries
    dews_states <- us_states |>
      dplyr::filter(STATE %in% states) |>
      sf::st_union()

    # Special handling for hybrid regions
    if (dews_name == "Pacific Northwest") {
      message("Combining PNW states with river basins...")

      # Verify CRS match before union
      if (!identical(sf::st_crs(dews_states), sf::st_crs(pnw_basins))) {
        pnw_basins <- sf::st_transform(pnw_basins, sf::st_crs(dews_states))
      }

      # Union all basin geometries first
      pnw_basins_union <- sf::st_union(pnw_basins)

      # Then union with states and dissolve
      dews_geom <- sf::st_union(dews_states, pnw_basins_union)

    } else if (dews_name == "Missouri River Basin") {
      message("Combining Missouri Basin with Dakota states...")

      # Verify CRS match before union
      if (!identical(sf::st_crs(dews_states), sf::st_crs(missouri_basin))) {
        missouri_basin <- sf::st_transform(missouri_basin, sf::st_crs(dews_states))
      }

      dews_geom <- sf::st_union(dews_states, missouri_basin)

    } else {
      # For state-only DEWS, use united state geometries
      dews_geom <- dews_states
    }

    # Store geometry with name (remove asterisk if present)
    clean_name <- gsub("\\*$", "", dews_name)
    dews_geometries[[clean_name]] <- dews_geom
  }

  # Combine all geometries into single sf object
  dews_sf <- do.call(rbind, lapply(names(dews_geometries), function(name) {
    sf::st_sf(
      DEWS = name,
      geometry = dews_geometries[[name]],
      crs = 4326
    )
  }))

  return(dews_sf)
}
