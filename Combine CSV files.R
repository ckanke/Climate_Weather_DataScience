# Create a vector of file names
# list all the files you wish to combine into one csv file
file_names <- c("/Users/USER/documents/data.csv")

library(dplyr)

# Create an empty data frame to store the combined data
combined_df <- data.frame()

# Loop through the files and append them to the combined data frame
for (file_name in file_names) {
  df <- read.csv(file_name)
  combined_df <- bind_rows(combined_df, df)
}

# Write the combined data to a new CSV file
write.csv(combined_df, "combined.csv", row.names = FALSE)

library(lubridate)

# Read in the CSV file with the original date column
df <- read.csv("combined.csv")

# Identify the different date formats in the date column
date_formats <- unique(sapply(df$DATE, function(x) {
  format(parse_date_time(x, orders = c("mdy", "dmy", "ymd")), "%Y-%m-%d")
}))

# Loop through the date formats and parse the date column
for (format in date_formats) {
  df$DATE <- ifelse(grepl(format, df$DATE),
                           format(parse_date_time(df$DATE, orders = c("mdy", "dmy", "ymd")), "%Y-%m-%d"),
                           df$DATE)
}

# Write the reformatted data to a new CSV file
write.csv(df, "reformatted.csv", row.names = FALSE)

formattedData <- read.csv("reformatted.csv")
