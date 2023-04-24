# Shiny application created by Kevin Zolea
# This application will be used to assist in the pre-screening efforts
# for our  property management business

library(shiny)
library(shinythemes)
library(shinyWidgets)
library(shinyjs)

fieldsMandatory <- c("name", "favourite_pkg")


ui <- fluidPage(theme = shinytheme("flatly"),
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
                titlePanel("Hinds Property Management"),
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
                      column(4, "Will you answer these questions truthfully"),
                      column(8, radioButtons("honesty", NULL, c("Yes I will", "No I won't")))
                    )
                  ),
                  
                  # Section 2
                  div(
                    class = "section-header",
                    "Income/Credit"
                  ),
                  div(
                    fluidRow(
                      column(4,"Do you have a steady source of income?"),
                      column(8,radioButtons("income", NULL, c("Yes I do", "No I don't")))
                    ),
                    fluidRow(
                      column(4, "Is your monthly gross income at least $4,800"),
                      column(8, radioButtons("income_amt", NULL, c("Yes it is", "No it's not")))
                    ),
                    fluidRow(
                      column(4, "What is your credit score?"),
                      column(8, radioButtons("credit_score", NULL, c("Below 600", "Above 600")))
                    )
                  ),
                  
                  # Section 3
                  div(
                    class = "section-header",
                    "Background/Past"
                  ),
                  div(
                    fluidRow(
                      column(4, "Are you comfortable completing a background check?"),
                      column(8, radioButtons("background_check", NULL, c("Yes I am", "No I'm not")))
                    ),
                    fluidRow(
                      column(4, "Have you ever been evicted or been given an eviction notice?"),
                      column(8, radioButtons("evicted", NULL, c("Yes I have", "No I haven't")))
                    ),
                    fluidRow(
                      column(4, "Are you comfortable with us obtaining references from your past landlords?"),
                      column(8, radioButtons("past_landlords", NULL, c("Yes I am", "No I'm not")))
                    ),
                    fluidRow(
                      column(4, "Will you receive great references from your past landlords?"),
                      column(8, radioButtons("great_ref", NULL, c("Yes I will", "No I won't")))
                    )
                  ),
                  
                  # Section 4
                  div(
                    class = "section-header",
                    "General"
                  ),
                  div(
                    fluidRow(
                      column(4, "Number of people in household"),
                      column(8, numericInput("num_people", NULL,0,min = 0, step = 1))
                    ),
                    fluidRow(
                      column(4, "Does anyone in your household have any pets?"),
                      column(8, radioButtons("pets", NULL, c("Yes", "No")))
                    ),
                    fluidRow(
                      column(4, "Does anyone in your household smoke?"),
                      column(8, radioButtons("smoke", NULL, c("Yes", "No")))
                    ),
                    fluidRow(
                      column(4, "If you are approved, when will you have the first months rent and deposit available?"),
                      column(8, textInput("move_in_date",NULL,value = "")))),
                # Section 4
                div(
                  class = "section-header",
                  "Contact Information"
                ),
                div(
                  fluidRow(
                    column(4, "Your name"),
                    column(8, textInput("name", NULL,
                                        placeholder = "Enter your name",
                                        value = ""))
                  ),
                  fluidRow(
                    column(4, "Your email"),
                    column(8, textInput("email", NULL,
                                        placeholder = "Enter your email",
                                        value = ""))
                  ),
                  fluidRow(
                    column(4, "Your phone number"),
                    column(8, textInput("number", NULL,
                                        placeholder = "Enter your phone number",
                                        value = ""))
                  )
                ),
                actionButton(inputId = "submit", label = "Submit", class = "btn-primary", width = "100%"))


server <- function(input, output,session) {
}

shinyApp(ui, server)
