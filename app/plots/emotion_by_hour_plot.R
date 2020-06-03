emotion_by_hour_plot = function(
  emote_df,
  emotions = c("Angry", "Scared", "Happy", "Sad", "Surprised", "Neutral")
) {
  plot_df = data.table::melt(
    emote_df,
    id.vars = c("active_app_name", "ts_hour"),
    measure.vars = emotions,
    variable.name = "emotion",
    value.name = "score"
  )

  plot_df = plot_df[!is.na(score) & !is.na(emotion), ]
  plot_df = plot_df[, .(score = mean(score)), by = .(ts_hour, emotion)]
  plot_df = plot_df[order(ts_hour), ]

  plotly::plot_ly(
    plot_df,
    x = ~ts_hour,
    y = ~score,
    color = ~emotion,
    type = "scatter",
    mode = "lines"
  ) %>%
    plotly::layout(
      hovermode = "compare",
      yaxis = list(title = "Mean Score"),
      xaxis = list(title = "Hour of Day"),
      title = ""
    ) %>%
    plotly::config(displayModeBar = FALSE)
}
