# Set your Census API key
tidycensus::census_api_key(Sys.getenv("CENSUS_API"))

# Get US States----
us_states <- tidycensus::get_acs(
  geography = "state",
  variables = "B01001_001",
  year = 2021,
  geometry = TRUE
) |>
  dplyr::select(GEOID, NAME) |>
  dplyr::mutate(STATE = state.abb[match(NAME, state.name)]) |>
  dplyr::select(STATE, NAME, geometry) |>
  sf::st_transform(4326)

# Get US Counties----
us_counties <- tidycensus::get_acs(
  geography = "county",
  variables = "B01001_001",
  year = 2021,
  geometry = TRUE
) |>
  dplyr::select(GEOID, NAME) |>
  tidyr::separate(NAME, into = c("NAME", "STATE"), sep = ", ") |>
  dplyr::mutate(STATE = state.abb[match(STATE, state.name)]) |>
  dplyr::select(NAME, STATE, GEOID, geometry) |>
  sf::st_transform(4326)

# Define DEWS regions----
dews_regions <- list(
  "California-Nevada" = c("CA", "NV"),
  "Midwest" = c("IL", "IN", "IA", "MI", "MN", "MO", "OH", "WI", "KY"),
  "Northeast" = c("CT", "ME", "MA", "NH", "NY", "RI", "VT"),
  "Pacific Northwest" = c("ID", "OR", "WA"),
  "Southeast" = c("AL", "FL", "GA", "NC", "SC", "TN", "VA"),
  "Southern Plains" = c("KS", "OK", "TX"),
  "Intermountain West" = c("AZ", "NM", "UT", "CO","WY"),
  "Missouri River Basin" = c("ND", "SD"),
  "Mid Atlantic*" = c("WV", "PA", "MD", "NJ", "DE"),
  "Lower Mississippi*" = c("LA", "AR", "MS")
)

# missouri river basin
huc2<-sf::st_read("extdata/WBD_National_GPKG.gpkg",layer = "WBDHU2")
missouri <- huc2[huc2$name=="Missouri Region",]

# Pacific northwest
huc4<-sf::st_read("extdata/WBD_National_GPKG.gpkg",layer = "WBDHU4")
pnw <- huc4[huc4$name %in% c("Upper Columbia", "Kootenai-Pend Oreille-Spokane"),]

# official boundaries:
nidis_dews <- nclimgrid:::create_dews_boundaries(
  us_states = us_states,
  missouri_basin = missouri,
  pnw_basins = pnw,
  dews_regions = dews_regions,
  extended = FALSE
)

# extended boundaries:
nidis_dews_ext <- nclimgrid:::create_dews_boundaries(
  us_states = us_states,
  missouri_basin = missouri,
  pnw_basins = pnw,
  dews_regions = dews_regions,
  extended = TRUE
)

# Census MSAs----
census_msas <- tidycensus::get_acs(
  geography = "cbsa",
  variables = "B01001_001",
  year = 2021,
  geometry = TRUE
) |>
  dplyr::select(GEOID, NAME, geometry) |>
  sf::st_transform(4326)

# Census Tracts----
census_tracts <- tidycensus::get_acs(
  geography = "tract",
  state = "NC",
  variables = "B01001_001",
  year = 2021,
  geometry = TRUE
) |>
  dplyr::select(GEOID, NAME, geometry) |>
  sf::st_transform(4326)

# Census Blocks (Wake County, NC example)----
census_blocks <- tidycensus::get_decennial(
  geography = "block",
  variables = "P1_001N",
  year = 2020,
  state = "NC",
  county = "Wake",
  geometry = TRUE
) |>
  dplyr::select(GEOID, geometry) |>
  sf::st_transform(4326)

# time series congressional districts
## https://cdmaps.polisci.ucla.edu/

# Save all datasets
usethis::use_data(us_states, overwrite = TRUE)
usethis::use_data(us_counties, overwrite = TRUE)
usethis::use_data(census_msas, overwrite = TRUE)
usethis::use_data(census_tracts, overwrite = TRUE)
usethis::use_data(census_blocks, overwrite = TRUE)
usethis::use_data(nidis_dews, overwrite = TRUE)
usethis::use_data(nidis_dews_ext, overwrite = TRUE)
