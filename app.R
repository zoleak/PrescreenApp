# Shiny application created by Kevin Zolea
# This application will be used to assist in the pre-screening efforts
# for our  property management business
##################################################################################
# load necessary packages for application to run
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(shinyjs)
library(googlesheets4)
##################################################################################
# Mandatory fields for inputs in application so users can't submit responses 
# without answering all the questions
fieldsMandatory <- c("honesty", "income","income_amt","credit_score","great_ref",
                     "evicted","background_check","past_landlords","name","number",
                     "email","num_people","pets","smoke","move_in_date")
##################################################################################
# function to create red asterick next to inputs
labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}

appCSS <- ".mandatory_star { color: red; }"
##################################################################################
# create a function to write data to Google Sheets
write_to_google_sheet <- function(data) {
  
  # replace this with your Google Sheet ID
  sheet_id <- "responses"
  
  # use the sheets_auth() function to authenticate your R script with Google Sheets
  sheets_auth()
  
  # write the data to the sheet
  sheet_append(
    ss = sheet_id, 
    data = data, 
    sheet = "Responses",
    col_names = TRUE
  )
}
##################################################################################
ui <- fluidPage(theme = shinytheme("flatly"),
                shinyjs::useShinyjs(),
                shinyjs::inlineCSS(appCSS),
                tags$head(tags$style(
                  HTML("
         .section-header {
           background-color: #4285F4;
           color: white;
           padding: 10px;
           font-weight: bold;
         }
         
         .centered {
           text-align: center;
         }
         
          ul {
      text-align: center;
      list-style-position: inside;
    }
         ")
                )),
                titlePanel(div("Hinds Property Management",
                           style='background-color:#4285F4;
                           color:white;')),
                fluidRow(
                  tags$h1(class = "centered",HTML("<u>Questionnaire for Rental Property</u>")),
                  p(class = "centered","Thank you for your interest. Please fill out this form in
    order to set up a showing time. 
    If this form is not filled out, you will not be able to set up a showing of the apartment. 
    If you have any questions, please don't hesitate to text me at 856-425-2091.", 
                    span("THIS IS NOT AN APPLICATION", style = "font-weight:bold; color:red;")
                  )),
                  fluidRow(
                    tags$h1(class = "centered",HTML("<u>Minimum Criteria</u>")),
                    tags$ul(
                      tags$li("Applicant must have current photo identification and a valid social security number."),
                      tags$li("Applicant's monthly household income must exceed three times the rent (gross). 
              All income must be from a verifiable source. Unverifiable income will not be considered."),
                      tags$li("Applicants must receive positive references from all previous landlords for the previous 5 years."),
                      tags$li("Applicant may not have any evictions or unpaid judgments from previous landlords."),
                      tags$li("Applicant must exhibit a responsible financial life. Credit score must be a minimum of 600."),
                      tags$li("A background check will be conducted on all applicants over 18."),
                      tags$li("Applicant must be a non-smoker."),
                      tags$li("Occupancy is limited to 2 people per bedroom."),
                      tags$li("No Pets"))),
                  tags$h3(class = "centered",HTML("<u>Please answer the following questions to the best of your ability.</u>")),
                  # Section 1
                  div(
                    class = "section-header",
                    "I agree to honestly answer this survey to the best of my abilities"
                  ),
                  div(
                    fluidRow(
                      #column(4, "Will you answer these questions truthfully"),
                      column(8, radioButtons("honesty",labelMandatory("Will you answer these 
                                                                      questions truthfully"), 
                                             c("Yes I will", "No I won't"),
                                             selected = character(0)))
                    )
                  ),
                  
                  # Section 2
                  div(
                    class = "section-header",
                    "Income/Credit"
                  ),
                  div(
                    fluidRow(
                      #column(4,"Do you have a steady source of income?"),
                      column(8,radioButtons("income",labelMandatory("Do you have a 
                                                                    steady source of income?"), 
                                            c("Yes I do", "No I don't"),
                                            selected = character(0)))
                    ),
                    fluidRow(
                      #column(4, "Is your monthly gross income at least $4,800"),
                      column(8, radioButtons("income_amt", labelMandatory("Is your monthly
                                                                          gross income 3 times the rent?"), 
                                             c("Yes it is", "No it's not"),
                                             selected = character(0)))
                    ),
                    fluidRow(
                      #column(4, "What is your credit score?"),
                      column(8, radioButtons("credit_score", labelMandatory("What is your credit score?"),
                                             c("Below 600", "Above 600"),
                                             selected = character(0)))
                    )
                  ),
                  
                  # Section 3
                  div(
                    class = "section-header",
                    "Background/Past"
                  ),
                  div(
                    fluidRow(
                      #column(4, "Are you comfortable completing a background check?"),
                      column(8, radioButtons("background_check", 
                      labelMandatory("Are you comfortable 
                                    completing a background check?"), 
                                             c("Yes I am", "No I'm not"),
                                             selected = character(0)))
                    ),
                    fluidRow(
                      #column(4, "Have you ever been evicted or been given an eviction notice?"),
                      column(8, radioButtons("evicted",
                                             labelMandatory("Have you ever been 
                                                            evicted or been given 
                                                            an eviction notice?"), 
                                             c("Yes I have", "No I haven't"),
                                             selected = character(0)))
                    ),
                    fluidRow(
                      #column(4, "Are you comfortable with us obtaining references from your past landlords?"),
                      column(8, radioButtons("past_landlords",
                                             labelMandatory("Are you comfortable with us 
                                                            obtaining references from your 
                                                            past landlords?"), 
                                             c("Yes I am", "No I'm not"),
                                             selected = character(0)))
                    ),
                    fluidRow(
                      #column(4, "Will you receive great references from your past landlords?"),
                      column(8, radioButtons("great_ref",labelMandatory("Will you receive great 
                                                                        references from your past landlords?"), 
                                             c("Yes I will", "No I won't"),
                                             selected = character(0)))
                    )
                  ),
                  
                  # Section 4
                  div(
                    class = "section-header",
                    "General"
                  ),
                  div(
                    fluidRow(
                      #column(4, "Number of people in household"),
                      column(8, numericInput("num_people",
                                             labelMandatory("Number of people in household")
                                             ,0,min = 0, step = 1))
                    ),
                    fluidRow(
                      #column(4, "Does anyone in your household have any pets?"),
                      column(8, radioButtons("pets", 
                                             labelMandatory("Does anyone in your
                                                            household have any pets?"),c("Yes", "No"),
                                             selected = character(0)))
                    ),
                    fluidRow(
                      #column(4, "Does anyone in your household smoke?"),
                      column(8, radioButtons("smoke",labelMandatory("Does anyone in your household
                                                                    smoke?")
                                             ,c("Yes", "No"),
                                             selected = character(0)))
                    ),
                    fluidRow(
                      #column(4, "If you are approved, when will you have the first months rent and deposit available?"),
                      column(8, dateInput("move_in_date",
                                          labelMandatory("If you are approved, 
                                                         when will you have the first months rent and deposit available?"),
                                          #,
                                          #placeholder = "Enter date",
                                         # value = ""
                                          )))),
                # Section 4
                div(
                  class = "section-header",
                  "Contact Information"
                ),
                div(
                  fluidRow(
                    #column(4, "Your name"),
                    column(8, textInput("name",labelMandatory("Your name"),NULL,
                                        placeholder = "Enter your name",
                                        value = ""))
                  ),
                  fluidRow(
                    #column(4, "Your email"),
                    column(8, textInput("email",labelMandatory("Your email"),NULL,
                                        placeholder = "Enter your email",
                                        value = ""))
                  ),
                  fluidRow(
                    #column(4, "Your phone number"),
                    column(8, textInput("number",labelMandatory("Your phone number"),NULL,
                                        placeholder = "Enter your phone number",
                                        value = ""))
                  )
                ),
                actionButton(inputId = "submit", label = "Submit", class = "btn-primary", 
                             width = "100%"))

##################################################################################
server <- function(input, output,session) {
  
  # Used to check and make sure all inputs are filled out before user can submit 
  # form through action button
  observe({
    mandatoryFilled <-
      vapply(fieldsMandatory,
             function(x) {
               !is.null(input[[x]]) && input[[x]] != ""
             },
             logical(1))
    mandatoryFilled <- all(mandatoryFilled)
    
    shinyjs::toggleState(id = "submit", condition = mandatoryFilled)
  })    
  ##################################################################################
  # create an event that triggers when the user submits the form
  observeEvent(input$submit, {
    
    # create a named vector of the user's responses
    user_responses <- c(
      "honesty" = input$honesty,
      "income" = input$income,
      "income_amt" = input$income_amt,
      "credit_score" = input$credit_score,
      "great_ref" = input$great_ref,
      "evicted" = input$evicted,
      "background_check" = input$background_check,
      "past_landlords" = input$past_landlords,
      "name" = input$name,
      "number" = input$number,
      "email" = input$email,
      "num_people" = input$num_people,
      "pets" = input$pets,
      "smoke" = input$smoke,
      "move_in_date" = input$move_in_date
    )
    
    # write the user's responses to the Google Sheet
    write_to_google_sheet(user_responses)
    
    # show a message to the user that their responses have been saved
    showModal(
      modalDialog(
        title = "Form Submitted",
        "Your responses have been saved. We will be in touch soon!",
        easyClose = TRUE,
        footer = NULL
      ))
    
    
  })
  
  
}
##################################################################################
shinyApp(ui, server)
