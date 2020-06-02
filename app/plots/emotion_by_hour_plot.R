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

  ggplot(plot_df, aes(x = ts_hour, y = score, color = emotion)) +
    geom_line() +
    labs(x = "Hour of Day",
         y = "Mean Score",
         title = "Mean Expression by Hour",
         color = "") +
    theme(legend.position = "left")
}
