#' United States State Boundaries
#'
#' A dataset containing the boundaries of all states in the United States.
#'
#' @format An sf object with 51 rows and 3 variables:
#' \describe{
#'   \item{STATE}{Character. The two-letter state abbreviation}
#'   \item{NAME}{Character. The full name of the state}
#'   \item{geometry}{sfc_MULTIPOLYGON. The geometry of the state boundary}
#' }
#' @source Walker K, Herman M (2024). \emph{tidycensus: Load US Census Boundary and Attribute
#'   Data as 'tidyverse' and 'sf'-Ready Data Frames}. R package version 1.6.5,
#'   \url{https://walker-data.com/tidycensus/}.
"us_states"

#' United States County Boundaries
#'
#' A dataset containing the boundaries of all counties in the United States.
#'
#' @format An sf object with approximately 3,142 rows and 4 variables:
#' \describe{
#'   \item{NAME}{Character. The name of the county}
#'   \item{STATE}{Character. The two-letter abbreviation of the state in which the county is located}
#'   \item{GEOID}{Character. The unique identifier for the county}
#'   \item{geometry}{sfc_MULTIPOLYGON. The geometry of the county boundary}
#' }
#' @source Walker K, Herman M (2024). \emph{tidycensus: Load US Census Boundary and Attribute
#'   Data as 'tidyverse' and 'sf'-Ready Data Frames}. R package version 1.6.5,
#'   \url{https://walker-data.com/tidycensus/}.
"us_counties"

#' United States Metropolitan Statistical Areas (MSAs)
#'
#' A dataset containing the boundaries of Metropolitan Statistical Areas in the United States.
#'
#' @format An sf object with variables:
#' \describe{
#'   \item{GEOID}{Character. The unique identifier for the MSA}
#'   \item{NAME}{Character. The name of the MSA}
#'   \item{geometry}{sfc_MULTIPOLYGON. The geometry of the MSA boundary}
#' }
#' @source Walker K, Herman M (2024). \emph{tidycensus: Load US Census Boundary and Attribute
#'   Data as 'tidyverse' and 'sf'-Ready Data Frames}. R package version 1.6.5,
#'   \url{https://walker-data.com/tidycensus/}.
"census_msas"

#' Census Tracts for North Carolina
#'
#' A dataset containing the boundaries of census tracts in North Carolina.
#'
#' @format An sf object with variables:
#' \describe{
#'   \item{GEOID}{Character. The unique identifier for the census tract}
#'   \item{NAME}{Character. The name or number of the census tract}
#'   \item{geometry}{sfc_MULTIPOLYGON. The geometry of the census tract boundary}
#' }
#' @source Walker K, Herman M (2024). \emph{tidycensus: Load US Census Boundary and Attribute
#'   Data as 'tidyverse' and 'sf'-Ready Data Frames}. R package version 1.6.5,
#'   \url{https://walker-data.com/tidycensus/}.
"census_tracts"

#' Census Blocks for Wake County, North Carolina
#'
#' A dataset containing the boundaries of census blocks in Wake County, North Carolina.
#'
#' @format An sf object with variables:
#' \describe{
#'   \item{GEOID}{Character. The unique identifier for the census block}
#'   \item{geometry}{sfc_MULTIPOLYGON. The geometry of the census block boundary}
#' }
#' @source Walker K, Herman M (2024). \emph{tidycensus: Load US Census Boundary and Attribute
#'   Data as 'tidyverse' and 'sf'-Ready Data Frames}. R package version 1.6.5,
#'   \url{https://walker-data.com/tidycensus/}.
"census_blocks"

#' NIDIS Drought Early Warning System (DEWS) Boundaries
#'
#' A spatial dataset containing the official boundaries of the National Integrated
#' Drought Information System (NIDIS) Drought Early Warning System (DEWS) regions.
#' The boundaries are constructed from a combination of state boundaries and river basins.
#'
#' @format An sf object with 2 variables:
#' \describe{
#'   \item{DEWS}{character. Name of the DEWS region}
#'   \item{geometry}{sfc_MULTIPOLYGON. Spatial geometry of the DEWS region}
#' }
#' @details The DEWS regions include:
#'   \itemize{
#'     \item California-Nevada (state-based)
#'     \item Midwest (state-based)
#'     \item Northeast (state-based)
#'     \item Pacific Northwest (states + Upper Columbia and Kootenai-Pend Oreille-Spokane basins)
#'     \item Southeast (state-based)
#'     \item Southern Plains (state-based)
#'     \item Intermountain West (state-based)
#'     \item Missouri River Basin (Missouri River Basin + ND and SD)
#'   }
#' @source
#'   State boundaries from US Census Bureau via tidycensus package
#'   \url{https://walker-data.com/tidycensus/}
#'
#'   River basin boundaries from USGS Watershed Boundary Dataset (WBD)
#'   \url{https://www.usgs.gov/national-hydrography/watershed-boundary-dataset}
#'
#'   DEWS region definitions from NIDIS
#'   \url{https://www.drought.gov/dews}
"nidis_dews"

#' Extended NIDIS Drought Early Warning System (DEWS) Boundaries
#'
#' A spatial dataset containing both official and extended boundaries of the National
#' Integrated Drought Information System (NIDIS) Drought Early Warning System (DEWS)
#' regions. The extended boundaries include additional regions to provide complete
#' coverage of the contiguous United States.
#'
#' @format An sf object with 2 variables:
#' \describe{
#'   \item{DEWS}{character. Name of the DEWS region}
#'   \item{geometry}{sfc_MULTIPOLYGON. Spatial geometry of the DEWS region}
#' }
#' @details Includes all regions from \code{nidis_dews} plus:
#'   \itemize{
#'     \item Mid Atlantic (WV, PA, MD, NJ)
#'     \item Lower Mississippi (LA, AK, MS)
#'   }
#' @source
#'   State boundaries from US Census Bureau via tidycensus package
#'   \url{https://walker-data.com/tidycensus/}
#'
#'   River basin boundaries from USGS Watershed Boundary Dataset (WBD)
#'   \url{https://www.usgs.gov/national-hydrography/watershed-boundary-dataset}
#'
#'   DEWS region definitions from NIDIS
#'   \url{https://www.drought.gov/dews}
"nidis_dews_ext"
