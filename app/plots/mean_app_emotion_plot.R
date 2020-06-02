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

  ggplot(plot_df, aes(x = active_app_name, y = score, fill = score)) +
    facet_wrap(~emotion) +
    geom_bar(stat = "identity") +
    labs(
      x = "",
      y = "",
      title = "Mean Expression by App",
      fill = "Score"
    ) +
    guides(fill = FALSE) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    coord_flip()
}
