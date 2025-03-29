# Real-Time Bus Tracking System

A Shiny web application that simulates real-time bus tracking along Broadway in New York City. The application uses R programming language for both frontend and backend, with Google Maps for visualization.

## Features

- Real-time bus location updates every 2 seconds
- Interactive Google Maps visualization
- Simulated bus movements along Broadway
- Bus information panel with current location details
- Start/Stop controls for the simulation

## Prerequisites

- R (version 3.6.0 or higher)
- RStudio (recommended for development)
- Google Maps API key

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/bus-tracker.git
cd bus-tracker
```

### 2. Install Required R Packages

Open R or RStudio and run:

```R
install.packages(c("shiny", "shinydashboard", "googleway", "dplyr"))
```

### 3. Get a Google Maps API Key

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or select an existing one)
3. From the Navigation menu, select "APIs & Services" > "Library"
4. Search for and enable the following APIs:
   - Maps JavaScript API
   - Directions API
   - Places API
5. Go to "APIs & Services" > "Credentials"
6. Click "Create credentials" and select "API key"
7. Copy your new API key

### 4. Set Up Your API Key

1. Create a file named `api_key.R` in the project directory
2. Add the following line to the file, replacing `YOUR_API_KEY` with your actual API key:

```R
api_key <- "YOUR_API_KEY"
```

### 5. Configure File Paths

Open the `app.R` file and update the file paths to point to your local files:

```R
# Load API key from file
source("YOUR_PATH_TO/api_key.R")

# Read bus routes data
bus_routes <- read.csv("YOUR_PATH_TO/bus_routes.csv", stringsAsFactors = FALSE)
```

For example:
```R
# For Windows
source("C:/Users/YourUsername/bus-tracker/api_key.R")

# For Mac/Linux
source("/home/YourUsername/bus-tracker/api_key.R")
```

You can also use relative paths if you're running the app from the project directory:
```R
source("api_key.R")
bus_routes <- read.csv("bus_routes.csv", stringsAsFactors = FALSE)
```

## Running the Application

1. Open `app.R` in RStudio
2. Click the "Run App" button, or run:

```R
shiny::runApp()
```

3. Click the "Start Bus" button to begin the simulation
4. Use the "Stop Bus" button to pause the simulation

## Project Structure

- `app.R`: Main application file containing both UI and server logic
- `bus_routes.csv`: Data file with predefined bus stops along Broadway
- `api_key.R`: File containing your Google Maps API key (not included in the repository)
- `README.md`: This documentation file

## Notes for Development

- The application simulates a single bus moving along Broadway
- The bus marker updates every 2 seconds
- The path is fixed (predefined in bus_routes.csv)
- Position updates are controlled by the Start/Stop buttons

## Security Notes

- **IMPORTANT**: Never commit your `api_key.R` file to GitHub
- Add `api_key.R` to your `.gitignore` file to prevent accidental commits
- Consider using environment variables for API keys in production environments

## License

[MIT](LICENSE)

## Acknowledgments

- This project was developed as part of a Programming for Data Science assignment
- Uses the [googleway](https://github.com/SymbolixAU/googleway) package for Google Maps integration
- Uses [Shiny](https://shiny.rstudio.com/) for the web application framework

Happy tracking! 
