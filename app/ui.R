library(shiny)
library(shinythemes)


navbarPage(
  windowTitle = "Emotion Tracker",
  title =
    div(
      img(src = "i_have_feelings.png",
          style = "margin-top: -14px; padding-right:10px;padding-bottom:10px",
          height = 60)
      ),
  theme = shinythemes::shinytheme("flatly"),
  tabPanel(
    tags$head(
      tags$link(rel = "shortcut icon",
                href = "i_have_feelings_small.png")
      ),
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
            start = A_MONTH_AGO,
            end = MAX_DATE
          ),  # dateRangeInput
          selectInput(
            inputId = "app_select",
            label = "Include Apps:",
            choices = APPS,
            selected = APPS_OF_INTEREST,
            multiple = TRUE
          ),  # selectInput
          radioButtons(
            inputId = "scl_radio",
            label = "",
            choices = c("Use raw data", "Use scaled data"),
            selected = "Use scaled data"
            )  # radioButtons
          )  # inputPanel
        ),  # column
      column(
        width = 8,
        align = "center",
        plotOutput("plot_1", width = "90%", height = 300),
        plotOutput("plot_2", width = "90%", height = 300),
        )  #column
      )  # fluidRow
    )  # tabPanel
  )  # navbarPage
