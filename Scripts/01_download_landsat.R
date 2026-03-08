#!/usr/bin/env Rscript
# 01_download_landsat.R
# Purpose: Download Landsat 8 imagery from USGS EarthExplorer for Kathmandu Valley
# Author: Pawan Thapa
# Date: 2025-03-08

# ============================================================================
# 1. LOAD REQUIRED PACKAGES
# ============================================================================

required_packages <- c(
  "getSpatialData",  # For querying and downloading Landsat data
  "sf",              # For spatial operations
  "terra",           # For raster manipulation
  "dplyr",           # For data manipulation
  "lubridate",       # For date handling
  "here"             # For reproducible file paths
)

# Install missing packages
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# ============================================================================
# 2. CONFIGURATION
# ============================================================================

# USGS EarthExplorer credentials (REGISTER AT: https://ers.cr.usgs.gov/register)
# IMPORTANT: Replace with your own credentials or set as environment variables
usgs_username <- Sys.getenv("USGS_USERNAME", "your_username_here")
usgs_password <- Sys.getenv("USGS_PASSWORD", "your_password_here")

# Define study area (Kathmandu Valley, Nepal)
# Approximate bounding box (path/row: 141/040)
study_area <- st_bbox(c(
  xmin = 85.20,  # Western boundary
  xmax = 85.55,  # Eastern boundary
  ymin = 27.60,  # Southern boundary
  ymax = 27.80   # Northern boundary
), crs = st_crs(4326)) %>%
  st_as_sfc() %>%
  st_sf()

# Define archive directory (where data will be stored)
archive_dir <- here("data", "raw", "landsat")
if (!dir.exists(archive_dir)) dir.create(archive_dir, recursive = TRUE)

# Define acquisition dates (summer and winter, 2014 and 2019)
acquisition_dates <- data.frame(
  season = c("winter", "summer", "winter", "summer"),
  year = c(2014, 2014, 2019, 2019),
  start_date = as.Date(c("2014-02-01", "2014-06-01", "2019-02-01", "2019-05-01")),
  end_date = as.Date(c("2014-02-28", "2014-08-31", "2019-02-28", "2019-08-31"))
)

# ============================================================================
# 3. INITIALIZE getSpatialData AND LOGIN TO USGS
# ============================================================================

cat("\n", paste(rep("=", 60), collapse = ""), "\n")
cat("STEP 1: Initializing getSpatialData and logging into USGS\n")
cat(paste(rep("=", 60), collapse = ""), "\n\n")

# Set archive directory for getSpatialData
set_archive(archive_dir)

# Login to USGS EarthExplorer
tryCatch({
  login_USGS(username = usgs_username, password = usgs_password)
  cat("✓ Successfully logged into USGS EarthExplorer\n")
}, error = function(e) {
  stop("Failed to login to USGS. Check your credentials.\nError: ", e$message)
})

# ============================================================================
# 4. SEARCH AND DOWNLOAD LANDSAT 8 SCENES
# ============================================================================

cat("\n", paste(rep("=", 60), collapse = ""), "\n")
cat("STEP 2: Searching and downloading Landsat 8 scenes\n")
cat(paste(rep("=", 60), collapse = ""), "\n\n")

# Set the area of interest
set_aoi(study_area)

# Data frame to store scene information
scene_records <- data.frame()

for (i in 1:nrow(acquisition_dates)) {
  season <- acquisition_dates$season[i]
  year <- acquisition_dates$year[i]
  start_date <- acquisition_dates$start_date[i]
  end_date <- acquisition_dates$end_date[i]
  
  cat(sprintf("\n--- Processing: %s %d (%s to %s) ---\n", 
              season, year, start_date, end_date))
  
  # Search for Landsat 8 Collection 2 Level-2 scenes
  tryCatch({
    records <- get_records(
      product = "LANDSAT_8_C2_L2",
      start_date = start_date,
      end_date = end_date,
      aoi = study_area,
      max_cloud = 20  # Maximum 20% cloud cover
    )
    
    if (nrow(records) > 0) {
      cat(sprintf("  ✓ Found %d scenes\n", nrow(records)))
      
      # Preview available records
      records$season <- season
      records$year <- year
      records$target_season <- paste0(season, "_", year)
      
      # Store records
      scene_records <- rbind(scene_records, records)
      
      # Download the scene with lowest cloud cover (prioritize clear scenes)
      records_sorted <- records[order(records$cloudcov), ]
      best_scene <- records_sorted[1, ]
      
      cat(sprintf("  → Selected scene: %s (cloud cover: %.1f%%)\n", 
                  best_scene$record_id, best_scene$cloudcov))
      
      # Download the selected scene
      download_path <- get_data(
        records = best_scene,
        dir_out = file.path(archive_dir, season, year),
        unzip = TRUE
      )
      
      cat(sprintf("  ✓ Downloaded to: %s\n", download_path))
      
    } else {
      cat("  ✗ No scenes found for this period\n")
    }
    
  }, error = function(e) {
    cat("  ✗ Error processing: ", e$message, "\n")
  })
}

# ============================================================================
# 5. SAVE SCENE METADATA
# ============================================================================

cat("\n", paste(rep("=", 60), collapse = ""), "\n")
cat("STEP 3: Saving scene metadata\n")
cat(paste(rep("=", 60), collapse = ""), "\n\n")

if (nrow(scene_records) > 0) {
  # Select and rename relevant columns for metadata
  metadata <- scene_records %>%
    select(
      record_id,
      product_name = product,
      acquisition_date = begin,
      season,
      year,
      cloudcov,
      target_season
    ) %>%
    mutate(
      acquisition_date = as.Date(acquisition_date),
      path = "141",
      row = "040"
    ) %>%
    arrange(acquisition_date)
  
  # Write metadata to CSV
  metadata_file <- here("data", "raw", "landsat_metadata.csv")
  write.csv(metadata, metadata_file, row.names = FALSE)
  
  cat(sprintf("✓ Metadata saved to: %s\n", metadata_file))
  cat(sprintf("  Total scenes downloaded: %d\n", nrow(metadata)))
  
} else {
  cat("✗ No scenes were downloaded. Check USGS credentials and study area.\n")
}

cat("\n", paste(rep("=", 60), collapse = ""), "\n")
cat("DOWNLOAD COMPLETE\n")
cat(paste(rep("=", 60), collapse = ""), "\n")

# Display summary table
if (exists("metadata")) {
  cat("\n📋 DOWNLOAD SUMMARY:\n")
  print(metadata[, c("acquisition_date", "season", "year", "cloudcov", "record_id")])
}
