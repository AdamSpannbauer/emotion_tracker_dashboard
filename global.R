library(data.table)
library(ggplot2)

# nolint
EMOTIONS = c("angry", "scared", "happy", "sad", "surprised", "neutral")


read_data = function() {
  data_path = "https://raw.githubusercontent.com/AdamSpannbauer/emotion_tracker/master/data/combined.csv"
  emotion_df = data.table::fread(data_path)
  emotion_df[, active_app_name := trimws(active_app_name)]
  emotion_df[active_app_name == "", active_app_name := NA_character_]

  return(emotion_df)
}


emotion_df = read_data()
emotion_df[, (EMOTIONS) := lapply(.SD, scale), .SDcols = EMOTIONS]

plot_df = data.table::melt(
  emotion_df,
  id.vars = c('active_app_name', 'timestamp'),
  variable.name = 'emotion',
  value.name = 'score'
)

plot_df = plot_df[!is.na(active_app_name) &
                    !is.na(score) &
                    !is.na(emotion),]

plot_df[, active_app_name := factor(active_app_name)]
ggplot(plot_df, aes(x = active_app_name, y = score, fill = score)) +
  facet_wrap( ~ emotion) +
  geom_bar(stat = "summary", fun = "mean", na.rm = TRUE) +
  labs(x = '', y = 'Scaled Emotion', fill = 'Score') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
