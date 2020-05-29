function(input, output, session) {
  emote_df = reactive({
    if (input$scl_radio == "Use scaled data") {
      d = SCL_EMOTION_DF
    } else {
      d = EMOTION_DF
    }

    d = d[active_app_name %in% input$app_select, ]
    d = d[ts_hour >= input$hour_slider[1] &
            ts_hour <= input$hour_slider[2], ]
    d = d[as.Date(timestamp) >= input$date_range[1] &
            as.Date(timestamp) >= input$date_range[1], ]
    d
  })


  output$mean_app_emotion_plot = renderPlot({
    plot_df = data.table::melt(
      emote_df(),
      id.vars = c("active_app_name", "timestamp"),
      measure.vars = EMOTIONS,
      variable.name = "emotion",
      value.name = "score"
    )

    plot_df = plot_df[!is.na(score) & !is.na(emotion), ]
    plot_df = plot_df[,
      .(score = mean(score)),
      by = .(active_app_name, emotion)
    ]

    ggplot(plot_df, aes(x = active_app_name, y = score, fill = score)) +
      facet_wrap(~emotion) +
      geom_bar(stat = "identity") +
      labs(x = "",
           y = "",
           title = "Mean Expression by App",
           fill = "Score") +
      guides(fill = FALSE) +
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      coord_flip()
  })


  output$emotion_by_hour_plot = renderPlot({
    plot_df = data.table::melt(
      emote_df(),
      id.vars = c("active_app_name", "ts_hour"),
      measure.vars = EMOTIONS,
      variable.name = "emotion",
      value.name = "score"
    )

    plot_df = plot_df[!is.na(score) & !is.na(emotion), ]
    plot_df = plot_df[, .(score = mean(score)), by = .(ts_hour, emotion)]

    ggplot(plot_df, aes(x = ts_hour, y = score, color = emotion)) +
      geom_line() +
      labs(x = "Hour of Day",
           y = "Mean Score",
           title = "Mean Expression by Hour",
           color = "") +
      theme(legend.position = "left")
  })
}
