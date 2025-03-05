
# load required packages
library(shiny)
library(shinysurveys)
library(here)
library(googledrive)
library(googlesheets4)

# authenticate myself

# set-up a google sheet to store the data from the form
# googlesheets4::gs4_create(name = "fieldwork-collection-data", 
# Create a sheet called main for all data to 
# go to the same place
# sheets = "main")
# googledrive::drive_mv("fieldwork-collection-data", path = "~/edna-pilot-sweden/")

# set gargle options
options(
  # whenever there is one account token found, use the cached token
  gargle_oauth_email = TRUE,
  # specify auth tokens should be stored in a hidden directory ".secrets"
  gargle_oauth_cache = ".secrets"
)

# googledrive::drive_auth(cache = here::here("edna-pilot-collect/.secrets"))
# googlesheets4::gs4_auth(cache = here::here("edna-pilot-collect/.secrets"))

# get the relevant sheet id
sheet_id <- googledrive::drive_get("~/edna-pilot-sweden/fieldwork-collection-data")$id

# read the survey form
survey_questions <- googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/12TPthdtxNueIXuXngxKzu_ZI4VG72VkPWiZeYqD3xCs/edit?usp=sharing")
survey_questions <- dplyr::as_tibble(survey_questions)

# define the shinyui
ui <- fluidPage(
  surveyOutput(
    survey_questions,
    survey_title = "eDNA pilot survey",
    survey_description = "Please fill out the details of your sample:"
  )
)

# define shiny server
server <- function(input, output, session) {
  renderSurvey()
  
  observeEvent(input$submit, {
    
    showModal(
      modalDialog(
        p("Thanks for submitting your responses! View the results")
      )
    )
    
    response_data <- getSurveyData()
    
    # read the output sheet
    values <- googlesheets4::read_sheet(ss = sheet_id, 
                                        sheet = "main")
    
    # check to see if our sheet has any existing data.
    # if not, let's write to it and set up column names. 
    # otherwise, let's append to it.
    
    if (nrow(values) == 0) {
      sheet_write(data = response_data,
                  ss = sheet_id,
                  sheet = "main")
    } else {
      sheet_append(data = response_data,
                   ss = sheet_id,
                   sheet = "main")
    }
    
  })
  
}

# Run the Shiny application
shinyApp(ui, server)
