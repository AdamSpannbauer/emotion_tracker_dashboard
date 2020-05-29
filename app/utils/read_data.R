library(data.table)

# nolint start
EMOTIONS = c("Angry", "Scared", "Happy", "Sad", "Surprised", "Neutral")
# nolint end

read_data = function(std_scale=FALSE) {
  # nolint start
  data_path = "https://raw.githubusercontent.com/AdamSpannbauer/emotion_tracker/master/data/combined.csv"
  # nolint end
  emotion_df = data.table::fread(data_path)

  # Convert emotion names to title case
  data.table::setnames(emotion_df, tolower(EMOTIONS), EMOTIONS)

  # Convert blank apps to "NA"
  emotion_df[, active_app_name := trimws(active_app_name)]
  emotion_df[active_app_name == "", active_app_name := "NA"]

  # Create columns for date parts
  emotion_df[, timestamp := as.POSIXct(timestamp, tz = "GMT")]
  emotion_df[, ts_year := data.table::year(timestamp)]
  emotion_df[, ts_month := data.table::month(timestamp)]
  emotion_df[, ts_mday := data.table::mday(timestamp)]
  emotion_df[, ts_wday := data.table::wday(timestamp)]

  # Convert to EST in prolly not a great way
  emotion_df[, ts_hour := data.table::hour(timestamp) - 4]
  emotion_df[ts_hour < 0, ts_hour := ts_hour + 24]

  emotion_df[, ts_minute := data.table::minute(timestamp)]

  emotion_df[, month := factor(
    ts_month,
    levels = 1:12,
    labels = c("Jan", "Feb", "Mar", "Apr", "May", "June",
               "July", "Aug", "Sept", "Oct", "Nov", "Dec")
  )]

  emotion_df[, weekday := data.table::wday(timestamp)]
  emotion_df[, weekday := factor(
    ts_wday,
    levels = 1:7,
    labels = c("Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat")
  )]

  # Optionally center and scale data
  if (std_scale) {
    emotion_df[, (EMOTIONS) := lapply(.SD, scale), .SDcols = EMOTIONS]
  }

  return(emotion_df)
}
