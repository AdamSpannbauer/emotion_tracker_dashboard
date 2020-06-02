library(shiny)
library(data.table)

source("plots/mean_app_emotion_plot.R")
source("plots/emotion_by_hour_plot.R")


function(input, output, session) {
  emote_df = reactive({
    if (input$scl_radio == "Use scaled data") {
      edf = SCL_EMOTION_DF
    } else {
      edf = EMOTION_DF
    }

    edf = edf[active_app_name %in% input$app_select, ]
    edf = edf[ts_hour >= input$hour_slider[1] &
                ts_hour <= input$hour_slider[2], ]
    edf = edf[as.Date(timestamp) >= input$date_range[1] &
                as.Date(timestamp) >= input$date_range[1], ]
    edf
  })


  output$plot_1 = renderPlot({
    mean_app_emotion_plot(emote_df(), EMOTIONS)
  })


  output$plot_2 = renderPlot({
    emotion_by_hour_plot(emote_df(), EMOTIONS)
  })
}
