#' Retrieve nClimGrid-Daily Data
#'
#' This function retrieves nClimGrid-Daily data from the AWS S3 bucket, allowing for
#' temporal and spatial filtering using various boundary types. It is recommended to use
#' this function for retrieving data over longer time periods or larger spatial areas,
#' rather than for single-day or single-point values.
#'
#' @param start_date Character string. Start date in "YYYY-MM-DD" format. Must be 1951-01-01 or later.
#' @param end_date Character string. End date in "YYYY-MM-DD" format.
#' @param variables Character vector. Any combination of "tmax", "tmin", "tavg", or "prcp".
#' @param boundary sf object. A spatial boundary to filter the data. If NULL, a boundary_type must be specified.
#' @param boundary_type Character string. One of "custom", "state", "county", "msa", "tract", "block", or "dews".
#' @param boundary_name Character string. Name of the boundary (e.g., state name) if using a predefined boundary type.
#' @param use_scaled Logical. If TRUE, use scaled data. If FALSE, use preliminary data. Default is TRUE.
#'
#' @return A stars object containing the filtered nClimGrid-Daily data.
#' @export
#'
#' @examples
#' \dontrun{
#' # Using a predefined state boundary for a month
#' data <- get_nclimgrid_data("2020-01-01", "2020-01-31", c("tmax", "tmin"),
#'                            boundary_type = "state", boundary_name = "North Carolina")
#' }
get_nclimgrid_data <- function(start_date, end_date, variables,
                               boundary = NULL, boundary_type = NULL, boundary_name = NULL,
                               use_scaled = TRUE) {
  # Validate inputs
  start_date <- as.Date(start_date)
  end_date <- as.Date(end_date)
  if (start_date < as.Date("1951-01-01")) {
    stop("start_date must be 1951-01-01 or later")
  }
  if (end_date > Sys.Date()) {
    warning("end_date is in the future. Using current date instead.")
    end_date <- Sys.Date()
  }

  valid_variables <- c("tmax", "tmin", "tavg", "prcp")
  if (!all(variables %in% valid_variables)) {
    stop("Invalid variable(s). Must be any of: ", paste(valid_variables, collapse = ", "))
  }

  valid_boundary_types <- c("custom", "state", "county", "msa", "tract", "block", "dews")
  if (is.null(boundary) && (is.null(boundary_type) || !boundary_type %in% valid_boundary_types)) {
    stop("Invalid or missing boundary_type. Must be one of: ", paste(valid_boundary_types, collapse = ", "))
  }

  # Get boundary if not provided
  if (is.null(boundary)) {
    if (is.null(boundary_name)) {
      stop("boundary_name must be provided when using a predefined boundary type")
    }
    boundary <- get_boundary(boundary_type, boundary_name)
  }
browser()
  # Ensure boundary is in the correct CRS (WGS84)
  boundary <- sf::st_transform(boundary, 4326)

  # Generate sequence of year-months
  date_seq <- seq(start_date, end_date, by = "month")
  year_months <- format(date_seq, "%Y%m")

  # Initialize empty list to store data
  data_list <- list()

  # Loop through year-months
  for (ym in year_months) {
    # Construct S3 path
    file_status <- if(use_scaled) "scaled" else "prelim"
    s3_path <- paste0("/vsis3/https://noaa-nclimgrid-daily-pds.s3.amazonaws.com/v1-0-0/grids/ncdd-", ym, "-grd-", file_status, ".nc")

        # Read the NetCDF file using stars
    stars_data <- stars::read_ncdf(s3_path, var = variables, proxy = TRUE)

    # Filter by date
    month_start <- as.Date(paste0(ym, "01"), format = "%Y%m%d")
    month_end <- seq(month_start, by = "month", length.out = 2)[2] - 1
    date_range <- seq(max(start_date, month_start), min(end_date, month_end), by = "day")
    stars_data <- stars_data[, , as.character(date_range)]

    # Crop to boundary
    cropped_data <- stars::st_crop(stars_data, boundary)

    # Add to list
    data_list[[ym]] <- cropped_data
  }

  # Combine all data
  combined_data <- do.call(c, c(data_list, along = "time"))

  return(combined_data)
}

# The get_boundary function remains the same as in the previous version
