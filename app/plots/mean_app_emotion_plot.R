mean_app_emotion_plot = function(
  emote_df,
  emotions = c("Angry", "Scared", "Happy", "Sad", "Surprised", "Neutral")
  ) {
  plot_df = data.table::melt(
    emote_df,
    id.vars = c("active_app_name", "timestamp"),
    measure.vars = emotions,
    variable.name = "emotion",
    value.name = "score"
  )

  plot_df = plot_df[!is.na(score) & !is.na(emotion), ]
  plot_df = plot_df[,
                    .(score = mean(score)),
                    by = .(active_app_name, emotion)]
  happiest = (
    plot_df[emotion == "Happy", ][order(-score), unique(active_app_name)]
  )
  plot_df[, active_app_name := factor(active_app_name, rev(happiest))]

  mean_app_barplots = lapply(emotions, function(e) {
    p_df = plot_df[emotion == e, ]

    plotly::plot_ly(
      p_df,
      x = ~score,
      y = ~active_app_name,
      type = "bar",
      name = e,
      legendgroup = "Score",
      marker = list(color = "rgb(31, 119, 180)")
    ) %>%
      plotly::add_annotations(
        text = e,
        x = 0.5,
        y = 1.2,
        yref = "paper",
        xref = "paper",
        xanchor = "middle",
        yanchor = "top",
        showarrow = FALSE,
        font = list(size = 15)
      ) %>%
      plotly::layout(
        xaxis = list(title = ""),
        yaxis = list(title = ""),
        title = e
      ) %>%
      plotly::config(displayModeBar = FALSE)
  })

  plotly::subplot(mean_app_barplots,
                  nrows = 2,
                  shareX = TRUE,
                  shareY = TRUE,
                  titleX = FALSE,
                  titleY = FALSE,
                  margin = 0.07) %>%
    plotly::layout(
      title = "",
      showlegend = FALSE
    )
}
