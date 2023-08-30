# Shiny application created by Kevin Zolea
# This application will be used to assist in the pre-screening efforts
# for our rental properties
##################################################################################
# load necessary packages for application to run
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(shinyjs)
library(googlesheets4)
library(emayili)
library(DT)
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
# Function to create label with red asterisk for mandatory inputs
labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}
# Function to create a list item with given text
createListItem <- function(text) {
  tags$li(text)
}
##################################################################################
ui <- fluidPage(theme = shinytheme("flatly"),
                shinyjs::useShinyjs(),
                tags$head(
                includeCSS("www/styles.css")
                ),
                fluidRow(
                  tags$h1(class = "centered",HTML("<u>Questionnaire for Rental Property</u>")),
                  p(class = "centered","Thank you for your interest. Please fill out this form in
    order to set up a showing time. 
    If this form is not filled out, you will not be able to set up a showing of the apartment. 
    If you have any questions, please don't hesitate to text me at 856-425-2091.", 
                    span("THIS IS NOT AN APPLICATION", style = "font-weight:bold; color:red;")
                  )),
                fluidRow(
                  tags$h1(class = "centered", HTML("<u>Minimum Criteria</u>")),
                  tags$ul(
                    createListItem("Applicant must have current photo identification and a valid social security number."),
                    createListItem("Applicant's monthly household income must exceed three times the rent (gross). All income must be from a verifiable source. Unverifiable income will not be considered."),
                    createListItem("Applicants must receive positive references from all previous landlords for the previous 5 years."),
                    createListItem("Applicant may not have any evictions or unpaid judgments from previous landlords."),
                    createListItem("Applicant must exhibit a responsible financial life. Credit score must be a minimum of 600."),
                    createListItem("A background check will be conducted on all applicants over 18."),
                    createListItem("Applicant must be a non-smoker."),
                    createListItem("Occupancy is limited to 2 people per bedroom."),
                    createListItem("No Pets")
                  )
                ),
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
                actionButton("review_info", "Submit", class = "btn-primary", width = "100%"))
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
          Please click the 'Schedule Showing' button below to schedule a showing.",
          size = "l",
          footer = tagList(
            actionButton("schedule_showing", "Schedule Showing", class = "btn-primary")
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
  
  
  
  # Handle the scheduling of showing when the "Schedule Showing" button is clicked
  observeEvent(input$schedule_showing, {
    showModal(
      modalDialog(
        title = "Schedule Showing",
        "Please choose a showing date/time from the calendar below. Once a date/time is selected
        in the calendar, please hit the 'Submit' button below.",br(),br(),
        size = "l",
        footer = tagList(
          actionButton("submit2", "Submit")
        ),
        airDatepickerInput(
          inputId = "showing_date",
          label = "Please Choose a Showing Time:",
          timepicker = TRUE,
          dateFormat = "MM-dd-yyyy"
        )
      )
    )
  })
  
  observeEvent(input$submit2, {
    showModal(
      modalDialog(
        "Thank you. We will reach out to you shortly!",
        footer = NULL
      )
    )
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
  
  #  # Send email to myself
  #  observeEvent(input$submit2, {
  #    # Get the applicant's details
  #    applicant_name <- input$name
  #    applicant_phone <- input$number
  #    showing_date <- input$showing_date
  #    applicant_email<-input$email
  #    
  #    # Format showing_date to non-military time format
  #    formatted_date <- format(as.POSIXct(showing_date), "%m-%d-%Y %I:%M %p")
  #    
  #    # Send an email to myself with the showing time
  #    email <- envelope()
  #      email <- email%>%
  #        from("kevin.zolea@gmail.com")%>%
  #        to("kevin.zolea@gmail.com")%>%
  #        subject("New Showing Time Request!")%>%
  #        text(paste0(
  #          "Applicant Name: ", applicant_name, "\n",
  #          "Applicant Phone: ", applicant_phone, "\n",
  #          "Showing Time: ", formatted_date))%>%
  #        render(
  #          paste0("[Approve Showing](mailto:", applicant_email, "?subject=Showing%20Time%20Confirmation&body=Dear%20", 
  #                 applicant_name, ",%0A%0AThank%20you%20for%20your%20interest!%0A%0AYour%20showing%20time%20is:%20", 
  #                 URLencode(formatted_date), "%0A%0AWe%20look%20forward%20to%20meeting%20you!%0A%0ABest%20regards,%0AHinds%20Property%20Management)")
  #        )
  #      smtp <- gmail(
  #        username = "kevin.zolea@gmail.com",
  #        password = Sys.getenv("GMAIL_PASSWORD")
  #      )
  #      
  #      smtp(email, verbose = TRUE)
  #      
  #  })  
  #
  
}
###################################################################################
shinyApp(ui, server)