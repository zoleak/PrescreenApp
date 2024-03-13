# Shiny application created by Kevin Zolea
# This application will be used to assist in the pre-screening efforts
# for our rental properties
##################################################################################
# load necessary packages for application to run
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(shinyjs)
library(shinycssloaders)
library(googlesheets4)
library(DT)
library(gridlayout)
library(bslib)
##################################################################################
# Read environmental variables
readRenviron(".Renviron")
##################################################################################
# Authorize the Google Sheets API
gs4_auth(email = "kevin.zolea@gmail.com", cache = ".secrets")
##################################################################################
# Define Google Sheet ID for data storage
google_sheet_id <- "1KTaRo3oUzuu1dPXc1rLjr1AHE_dKHdtQI7IqqmUMKdo"
##################################################################################
# Mandatory fields for inputs in the application
# Users can't submit responses without answering all the questions
fieldsMandatory <- c("honesty", "income","income_amt","credit_score","great_ref",
                     "evicted","background_check","past_landlords","name","number",
                     "email","num_people","pets","smoke","move_in_date")
##################################################################################
##################################################################################
# Function to create label with red asterisk for mandatory inputs
labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}
##################################################################################
ui <- grid_page(
  shinyjs::useShinyjs(),
  theme = bs_theme(preset = "sketchy",
                   primary = "#4285F4"),
  layout = c(
    "header  header",
    "sidebar plot  "
  ),
  row_sizes = c(
    "40px",
    "1fr"
  ),
  col_sizes = c(
    "650px",
    "1fr"
  ),
  gap_size = "10px",
  tags$head(
      includeCSS("www/styles.css")),
  grid_card(
    area = "sidebar",
    card_header(
      tags$p("Thank you for your interest in our apartment! To schedule a viewing, please complete this quick questionnaire. 
              Completing this form will help us assess your interest and suitability for the apartment."),
      tags$b(style = "color: red;", 
                "This is not a formal application for the apartment."),
      tags$p("For questions, feel free to text me at 856-425-2091."),
      # Include the EHO logo
      img(src = "https://www.nar.realtor/sites/default/files/downloadable/equal-housing-opportunity-logo-1200w.png", 
          height = 50, width = 50, align = "right")
    ),
    card_body(
      tags$u(tags$b("Minimum Criteria
                  ")),
      markdown(
        mds = c(
          "1.) Applicant must have current photo identification and a valid social security number.",
          "",
          "2.) Applicant's monthly household income must exceed three times the rent (gross). All income must be from a verifiable source. Unverifiable income will not be considered.",
          "",
          "3.) Applicants must receive positive references from all previous landlords for the previous 5 years.",
          "",
          "4.) Applicant may not have any evictions or unpaid judgments from previous landlords.",
          "",
          "5.) Applicant must exhibit a responsible financial life. Credit score must be a minimum of 600.",
          "",
          "6.) A background check will be conducted on all applicants over 18.",
          "",
          "7.) Applicant must be a non-smoker.",
          "",
          "8.) Occupancy is limited to 2 people per bedroom.",
          "",
          "9.) No pets."
        )
      )
    )
  ),
  grid_card_text(
    area = "header",
    content = "Apartment Questionnaire",
    alignment = "center",
    is_title = FALSE
  ),
  grid_card(
    area = "plot",
    card_header(
      tags$b("Please answer the following questions to the best of your ability.
                  "
    ),
    card_body(
      radioButtons(
        inputId = "honesty",
        choices = c(
          "Yes I will",
          "No I won't"
        ),
        selected = character(0),
        width = "100%",
        label = labelMandatory("Will you answer these questions truthfully?")
      ),
      radioButtons(
        inputId = "income",
        choices = c(
          "Yes I do",
          "No I don't"
        ),
        selected = character(0),
        width = "100%",
        label = labelMandatory("Do you have a steady source of income?")
      ),
      radioButtons(
        selected = character(0),
        inputId = "income_amt",
        label = labelMandatory("Is your monthly gross income 3 times the rent?"),
        choices = c(
          "Yes it is",
          "No it's not"
        )
      ),
      radioButtons(
        selected = character(0),
        inputId = "credit_score",
        label = labelMandatory("What is your credit score?"),
        choices = c(
          "Below 600",
          "Above 600"
        )
      ),
      radioButtons(
        selected = character(0),
        inputId = "background_check",
        label = labelMandatory("Are you comfortable 
                                            completing a background check?"),
        choices = c(
          "Yes I am",
          "No I'm not"
        )
      )%>%
        tooltip("A background check will be conducted in accordance with the Fair Chance in Housing Act. ",
                placement = "right"),
      radioButtons(
        selected = character(0),
        inputId = "evicted",
        label = labelMandatory("Have you ever been 
                                          evicted or been given 
                                          an eviction notice?"),
        choices = c(
          "Yes I have",
          "No I haven't"
        )
      ),
      radioButtons(
        selected = character(0),
        inputId = "past_landlords",
        label = labelMandatory("Are you comfortable with us 
                                obtaining references from your 
                                past landlords?"),
        choices = c(
          "Yes I am",
          "No I'm not"
        )
      ),
      radioButtons(
        selected = character(0),
        inputId = "great_ref",
        label = labelMandatory("Will you receive great 
                               references from your past landlords?"),
        choices = c(
          "Yes I will",
          "No I won't"
        )
      ),
      numericInput(
        min = 0,
        step = 1,
        inputId = "num_people",
        label = labelMandatory("Number of people in household"),
        value = 0
      ),
      radioButtons(
        selected = character(0),
        inputId = "pets",
        label = labelMandatory("Does anyone in your
                            household have any pets?"),
        choices = c(
          "Yes",
          "No"
        )
      ),
      radioButtons(
        selected = character(0),
        inputId = "smoke",
        label = labelMandatory("Does anyone in your household
                            smoke?"),
        choices = c(
          "Yes",
          "No"
        )
      ),
      dateInput("move_in_date",
                      labelMandatory("If you are approved, 
                                      when will you have the first months rent and deposit available?")),
      textInput(
        placeholder = "Enter your name",
        value = "",
        inputId = "name",
        label = labelMandatory("Your name"),
        NULL
      ),
      textInput(
        placeholder = "Enter your email",
        value = "",
        inputId = "email",
        label = labelMandatory("Your email"),
        NULL
      ),
      textInput(
        placeholder = "Enter your phone number",
        value = "",
        inputId = "number",
        label = labelMandatory("Your phone number"),
        NULL
      )
    ),
    card_footer(
      actionBttn(
              inputId = "review_info",
              label = "Submit",
              style = "pill", 
              color = "primary")
))))
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
      
      shinyjs::toggleState(id = "review_info", condition = mandatoryFilled)
    })    
    ####################################################################################  
    # Observer for the "Review Information" button
    observeEvent(input$review_info, {
      showModal(
        modalDialog(
          title = "Review Information",
          size = "l",
          fluidRow(
            "Please review the following information before submitting. If
          everything looks good, please submit.",
            DTOutput("review_table")  # Display the formatted user inputs
          ),
          footer = tagList(
            modalButton("Edit Information"),
            actionButton(inputId = "submit", label = "Submit", class = "btn-primary"))
        )
      )
    })
    ################################################################################## 
    # Observer to render the user's inputs for review
    output$review_table <- renderDT({
      user_input <- data.frame(
        "Question" = c(
          "Will you answer these questions truthfully?",
          "Do you have a steady source of income?",
          "Is your monthly gross income 3 times the rent?",
          "What is your credit score?",
          "Are you comfortable completing a background check?",
          "Have you ever been evicted or been given an eviction notice?",
          "Are you comfortable with us obtaining references from your past landlords?",
          "Will you receive great references from your past landlords?",
          "Number of people in household",
          "Does anyone in your household have any pets?",
          "Does anyone in your household smoke?",
          "If you are approved, when will you have the first months rent and deposit available?",
          "Your name",
          "Your email",
          "Your phone number"
        ),
        "Answer" = c(
          input$honesty,
          input$income,
          input$income_amt,
          input$credit_score,
          input$background_check,
          input$evicted,
          input$past_landlords,
          input$great_ref,
          input$num_people,
          input$pets,
          input$smoke,
          format(input$move_in_date, "%Y-%m-%d"),  # Format the date
          input$name,
          input$email,
          input$number
        )
      )
      
      datatable(
        user_input,
        rownames = FALSE,
        options = list(dom = 't', paging = FALSE, ordering = FALSE)
      )
      
    })
    ##################################################################################  
    # observeEvent is a reactive function that will run when the submit button is clicked
    observeEvent(input$submit, {
      # Check if user meets all criteria
      # if all the criteria are met, then the user will be shown a success message
      if (input$honesty == "Yes I will" &&
          input$income == "Yes I do" &&
          input$income_amt == "Yes it is" &&
          input$credit_score == "Above 600" &&
          input$past_landlords == "Yes I am" &&
          input$great_ref == "Yes I will" &&
          input$evicted == "No I haven't" &&
          input$background_check == "Yes I am" &&
          input$smoke == "No" &&
          input$pets == "No") {
        # If the user meets all criteria, show the success message
        showModal(
          modalDialog(
            title = paste("Congratulations", input$name,"!"),
            "You meet all our minimum criteria and are eligible for the rental property. 
          Please schedule your showing time below!",
            size = "l",
            footer = tagList(
              # Add calendly iframe so users can schedule showing
              tags$iframe(
                src = "https://calendly.com/kevin-zolea/apartment-showing", 
                width = "100%",
                style="height: 100vh;",
                scrolling = 'no'
              )
            )
          ))
        # If the criteria are not met, then the user will be shown an error message
      } else {
        # If user does not meet all criteria, show error message
        showModal(
          modalDialog(
            title = "Criteria Not Met",
            "Unfortunately, we regret to inform you that at this time, 
        you do not meet the rental criteria for this property. Thank you for
        your time.",
            size = "l",
            icon = icon("exclamation-triangle")
          ))
      }
    })
    
    # Save user's input to Google Sheet when the submit button is clicked
    observeEvent(input$submit, {
      # Create a data frame with the user's input
      data <- data.frame(
        honesty = input$honesty,
        income = input$income,
        income_amt = input$income_amt,
        credit_score = input$credit_score,
        background_check = input$background_check,
        evicted = input$evicted,
        great_ref = input$great_ref,
        past_landlords = input$past_landlords,
        num_people = input$num_people,
        pets = input$pets,
        smoke = input$smoke,
        move_in_date = input$move_in_date,
        name = input$name,
        email = input$email,
        number = input$number
      )
      
      # Save the data frame to the Google Sheet
      sheet_append(data, ss = google_sheet_id, sheet = "Sheet1")
    })
    
    
  }
  ###################################################################################
  shinyApp(ui, server)
