
# map of the sample sites

# Install leaflet package if not already installed
if (!require("leaflet")) {
  install.packages("leaflet")
  library(leaflet)
}

# Create a data frame with the coordinates and site names
locations <- data.frame(
  name = c("Nya varvet", "Vrango", "Saltholmen", "Natrium"),
  lat = c(57.685067, 57.565235, 57.658824, 57.685488),
  lng = c(11.889722, 11.792627, 11.844036, 11.959382)
)

# Create an interactive leaflet map
leaflet(locations) %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng = ~lng, lat = ~lat, popup = ~name) %>%  # Add markers with popups
  setView(lng = mean(locations$lng), lat = mean(locations$lat), zoom = 12)  # Center the map
