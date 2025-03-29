# Load required packages
library(shiny)
library(googleway)
library(dplyr)
library(shinydashboard)

# Load API key from file
source("api_key.R")

# Read bus routes data
bus_routes <- read.csv("bus_routes.csv", stringsAsFactors = FALSE)

# Print the column names to debug
print("Column names in bus_routes:")
print(names(bus_routes))

# Filter to only route 1, bus 101
bus_route <- bus_routes %>% 
  filter(route_id == 1, bus_id == 101) %>%
  arrange(sequence)

# Print the structure of bus_route to debug
print("Structure of bus_route:")
print(str(bus_route))

# UI Definition
ui <- dashboardPage(
  dashboardHeader(title = "Real-Time Bus Tracking - Broadway"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Map View", tabName = "map", icon = icon("map")),
      actionButton("start_button", "Start Bus", icon = icon("play")),
      actionButton("stop_button", "Stop Bus", icon = icon("stop"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "map",
        fluidRow(
          box(
            width = 12,
            google_mapOutput("map", height = "600px")
          )
        ),
        fluidRow(
          box(
            width = 6,
            title = "Bus Information",
            verbatimTextOutput("bus_info")
          ),
          box(
            width = 6,
            title = "Instructions",
            tags$p("This app shows a bus moving along Broadway in New York City."),
            tags$p("The bus updates its position every 2 seconds."), 
            tags$p("Click 'Start Bus' to begin the simulation."),
            tags$p("The red marker represents the bus's current location."),
            tags$p("The blue line shows the complete route.")
          )
        )
      )
    )
  )
)

# Server Definition
server <- function(input, output, session) {
  
  # Create reactive values to manage state
  rv <- reactiveValues(
    position_index = 1,
    timer_active = FALSE,
    last_update = Sys.time()
  )
  
  # Initialize the map
  output$map <- renderGoogle_map({
    # Basic map without polylines first
    google_map(key = api_key,
               location = c(bus_route$latitude[1], bus_route$longitude[1]),
               zoom = 15,
               map_type_control = TRUE)
  })
  
  # Add the route polyline after map is created
  observe({
    # Only run once when the app starts
    if (!rv$initialized) {
      # Manually add the polyline after map creation
      google_map_update(map_id = "map") %>%
        add_polylines(
          data = bus_route,
          lat = "latitude", 
          lon = "longitude",
          stroke_colour = "#0000FF",
          stroke_weight = 5,
          stroke_opacity = 0.7
        )
      
      # Mark as initialized
      rv$initialized <- TRUE
    }
  })
  
  # Bus information output
  output$bus_info <- renderText({
    # Re-render when position changes
    if(rv$timer_active) {
      invalidateLater(100)
    }
    
    # Get current position data
    current_pos <- bus_route[rv$position_index, ]
    
    paste(
      "Bus ID: 101",
      paste("Current Stop:", current_pos$stop_name),
      paste("Latitude:", current_pos$latitude),
      paste("Longitude:", current_pos$longitude),
      paste("Sequence:", current_pos$sequence),
      paste("Last Updated:", format(rv$last_update, "%H:%M:%S")),
      sep = "\n"
    )
  })
  
  # Update the bus position markers
  observe({
    # Re-render on position change or when timer is active
    if(rv$timer_active) {
      invalidateLater(100)
      
      # Check if 2 seconds have passed
      current_time <- Sys.time()
      if(as.numeric(difftime(current_time, rv$last_update, units = "secs")) >= 2) {
        # Update position
        rv$position_index <- (rv$position_index %% nrow(bus_route)) + 1
        rv$last_update <- current_time
        
        # Log update
        print(paste("Updated to position", rv$position_index, "at", format(current_time, "%H:%M:%S")))
      }
    }
    
    # Get the current bus position
    current_pos <- bus_route[rv$position_index, ]
    
    # Update the map marker
    google_map_update(map_id = "map") %>%
      clear_markers() %>%
      add_markers(
        data = current_pos,
        lat = "latitude",
        lon = "longitude",
        marker_icon = "https://maps.google.com/mapfiles/ms/icons/red-dot.png",
        info_window = paste(
          "<b>Bus ID:</b> 101<br>",
          "<b>Stop:</b> ", current_pos$stop_name, "<br>",
          "<b>Sequence:</b> ", current_pos$sequence
        )
      )
  })
  
  # Start button handler
  observeEvent(input$start_button, {
    rv$timer_active <- TRUE
    rv$last_update <- Sys.time()
    print("Bus simulation started")
  })
  
  # Stop button handler
  observeEvent(input$stop_button, {
    rv$timer_active <- FALSE
    print("Bus simulation stopped")
  })
  
  # Initialize reactive values
  rv$initialized <- FALSE
}

# Run the application
shinyApp(ui, server) 