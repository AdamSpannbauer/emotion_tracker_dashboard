library(shiny)
library(shinythemes)


navbarPage(
  title = "Emotion Tracker",
  theme = shinythemes::shinytheme("flatly"),
  tabPanel(
    title =  "Summary Charts",
    fluidRow(
      column(
        width = 4,
        align = "center",
        inputPanel(
          sliderInput(
            inputId = "hour_slider",
            label = "Include Hours:",
            min = MIN_HOUR,
            max = MAX_HOUR,
            step = 1,
            value = c(MIN_HOUR, MAX_HOUR)
          ),  # sliderInput
          dateRangeInput(
            inputId = "date_range",
            label = "Include Dates:",
            min = MIN_DATE,
            max = MAX_DATE,
            start = MIN_DATE,
            end = MAX_DATE
          ),  # dateRangeInput
          selectInput(
            inputId = "app_select",
            label = "Include Apps:",
            choices = APPS,
            selected = APPS,
            multiple = TRUE
          ),  # selectInput
          radioButtons(
            inputId = "scl_radio",
            label = "",
            choices = c("Use raw data", "Use scaled data"),
            selected = "Use raw data"
            )  # radioButtons
          )  # inputPanel
        ),  # column
      column(
        width = 8,
        align = "center",
        plotOutput("mean_app_emotion_plot", width = "90%", height = 300),
        plotOutput("emotion_by_hour_plot", width = "90%", height = 300),
        )  #column
      )  # fluidRow
    )  # tabPanel
  )  # navbarPage
