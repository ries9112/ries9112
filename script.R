library(PredictCrypto)
library(ggplot2)
library(anytime)
library(ggthemes)
library(fs)
library(gganimate)
library(magick)
library(dplyr)

# Pull crypto_data data:
crypto_data <- get_prices_by_exchange()

# Filter data to top 20 ranked cryptos
#crypto_data <- subset(crypto_data, Rank < 20)

# Remove USD coins:
#crypto_data <- subset(crypto_data, Name != c(crypto_data$Name[!grepl("USD", crypto_data$Name)]))

# Only get Binance cryptos
crypto_data <- subset(crypto_data, Exchange == 'Binance')

# Arrange data so that Bitcoin is first
crypto_data <- arrange(crypto_data, -highest_bid_1_price_usd)

# Convert date/time
crypto_data$date_time_utc <- as.POSIXct(crypto_data$date_time_utc, format="%Y-%m-%d %H:%M:%S")

# Filter data to last 31 days
#crypto_data <- subset(crypto_data, date_time_utc > Sys.time()-60*60*24*31)

# Make gganimated plot:
anim <- animate(ggplot(data = crypto_data,
                       aes(x = as.POSIXct(date_time_utc), y = highest_bid_1_price_usd, group = Name)) + 
                  geom_line() +
                  labs(subtitle=paste('Latest data collected on:', max(crypto_data$date_time_utc), ' - MST'),
                       caption='Data source: shrimpy.io') + 
                  stat_smooth() + 
                  theme_economist() +
                  xlab('Date Time Collected (Colorado - MST)') +
                  ylab('Price USD ($)') +
                  transition_states(Name) +
                  ggtitle('{closest_state} Price ($) Past 31 Days') +
                  view_follow(),fps=1)


# Delete animation before making new one
file_delete('crypto_plot.gif')

# Save gif
image_write(anim, path='crypto_plot.gif')

# Second gif for last 2 days of data
# Filter to last 2 days
crypto_data_2 <- subset(crypto_data, date_time_utc > Sys.time()-60*60*24*31*4) # not sure why filter not working as expected anymore

# Make gganimated plot:
anim <- animate(ggplot(data = crypto_data_2,
               aes(x = as.POSIXct(date_time_utc), y = highest_bid_1_price_usd, group = Name)) + 
               geom_line() +
               geom_point() +
               labs(subtitle=paste('Latest data collected on:', max(crypto_data_2$date_time_utc), ' - MST'),
                    caption='Data source: shrimpy.io') + 
               theme_economist() +
               xlab('Date Time Collected (Colorado - MST)') +
               ylab('Price USD ($)') +
               transition_states(Name) +
               ggtitle('{closest_state} Price ($) Past 31 Days') +
               view_follow(),fps=1)

# Delete animation before making new one
file_delete('crypto_plot_2.gif')

# Save gif
image_write(anim, path='crypto_plot_2.gif')

# Make more charts
# Filter to last 7 days
#crypto_data_7 <- subset(crypto_data, date_time_utc > Sys.time()-60*60*24*7)

# Make gganimated plot of reported 24h volume:
#anim <- animate(ggplot(data = crypto_data_7,
#               aes(x = as.POSIXct(date_time_utc), y = Reported24hVolume, group = Name)) + 
#                geom_point() +
#                labs(subtitle=paste('Latest data collected on:', max(crypto_data_7$date_time_utc), ' - MST'),
#                     caption='Data source: crypto_data.io') + 
#                stat_smooth() + 
#                theme_economist() +
#                xlab('Date Time Collected (Colorado - MST)') +
#                ylab('Reported Volume (24 hour period)') +
#                transition_states(Name) +
#                ggtitle('{closest_state} Reported Volume ($) Past 7 Days') +
#                view_follow(),fps=1)

# Delete animation before making new one
#file_delete('crypto_volume.gif')

# Save gif
#image_write(anim, path='crypto_volume.gif')


# Make gganimated plot of GitHub Stars:
#anim <- animate(ggplot(data = crypto_data_7,
#               aes(x = as.POSIXct(date_time_utc), y = Git_Stars, group = Name)) + 
#                geom_point() +
#                labs(subtitle=paste('Latest data collected on:', max(crypto_data_7$date_time_utc), ' - MST'),
#                     caption='Data source: crypto_data.io') + 
#                stat_smooth() + 
#                theme_economist() +
#                xlab('Date Time Collected (Colorado - MST)') +
#                ylab('GitHub Stars') +
#                transition_states(Name) +
#                ggtitle('{closest_state} - GitHub Stars - Past 7 Days') +
#                view_follow(),fps=1)

# Delete animation before making new one
#file_delete('crypto_git_stars.gif')

# Save gif
#image_write(anim, path='crypto_git_stars.gif')

# Make gganimated plot of active addresses:
#anim <- animate(ggplot(data = crypto_data_7,
#               aes(x = as.POSIXct(date_time_utc), y = ActiveAddresses, group = Name)) + 
#                geom_point() +
#                labs(subtitle=paste('Latest data collected on:', max(crypto_data_7$date_time_utc), ' - MST'),
#                     caption='Data source: crypto_data.io') + 
#                stat_smooth() + 
#                theme_economist() +
#                xlab('Date Time Collected (Colorado - MST)') +
#                ylab('Active Addresses') +
#                transition_states(Name) +
#                ggtitle('{closest_state} - Number of Active Addresses - Past 7 Days') +
#                view_follow(),fps=1)

# Delete animation before making new one
#file_delete('crypto_addresses.gif')


