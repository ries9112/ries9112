library(pins)
library(ggplot2)
library(anytime)
library(ggthemes)
library(fs)
library(gganimate)
library(magick)
library(dplyr)

board_register("https://raw.githubusercontent.com/predictcrypto/pins/master/","hitBTC_orderbooks_github")

hitBTC <- pin_get("hitBTC_orderbooks_github", "hitBTC_orderbooks_github")

# Filter data to top 20 ranked cryptos
#hitBTC <- subset(hitBTC, Rank < 20)

# Unique data
hitBTC <- distinct(hitBTC, pkey, .keep_all = T)

# Remove USD coins:
#hitBTC <- subset(hitBTC, Name != c(hitBTC$Name[!grepl("USD", hitBTC$Name)]))

# Convert date/time
hitBTC$date_time_utc <- as.POSIXct(hitBTC$date_time_utc, format="%Y-%m-%d %H:%M:%S")

# Filter data to last 31 days
hitBTC <- subset(hitBTC, date_time_utc > Sys.time()-60*60*24*31)

# Rename price field
hitBTC <- rename(hitBTC, PriceUSD = 'bid_1_price')

# Make gganimated plot:
anim <- animate(ggplot(data = hitBTC,
               aes(x = as.POSIXct(date_time_utc), y = PriceUSD, group = symbol)) + 
                geom_point() +
                labs(subtitle=paste('Latest data collected on:', max(hitBTC$date_time_utc), ' - UTC'),
                     caption='Data source: HitBTC.com') + 
                stat_smooth() + 
                theme_economist() +
                xlab('Date Time Collected (UTC)') +
                ylab('Price USD ($)') +
                transition_states(symbol) +
                ggtitle('{closest_state} Price ($) Past 31 Days') +
                view_follow(),fps=1)

# Delete animation before making new one
file_delete('crypto_plot.gif')

# Save gif
image_write(anim, path='crypto_plot.gif')

# Second gif for last 2 days of data
# Filter to last 2 days
hitBTC_2 <- subset(hitBTC, date_time_utc > Sys.time()-60*60*24*2)

# Make gganimated plot:
anim <- animate(ggplot(data = hitBTC_2,
               aes(x = as.POSIXct(date_time_utc), y = PriceUSD, group = symbol)) + 
               #geom_line() +
               geom_point() +
               labs(subtitle=paste('Latest data collected on:', max(hitBTC_2$date_time_utc), ' - UTC'),
                    caption='Data source: HitBTC.com') + 
               theme_economist() +
               xlab('Date Time Collected (UTC)') +
               ylab('Price USD ($)') +
               transition_states(symbol) +
               ggtitle('{closest_state} Price ($) Past 2 Days') +
               view_follow(),fps=1)

# Delete animation before making new one
file_delete('crypto_plot_2.gif')

# Save gif
image_write(anim, path='crypto_plot_2.gif')

# Make more charts
# Filter to last 7 days
#hitBTC_7 <- subset(hitBTC, date_time_utc > Sys.time()-60*60*24*7)

# Make gganimated plot of reported 24h volume:
#anim <- animate(ggplot(data = hitBTC_7,
#               aes(x = as.POSIXct(date_time_utc), y = Reported24hVolume, group = symbol)) + 
#                geom_point() +
#                labs(subtitle=paste('Latest data collected on:', max(hitBTC_7$date_time_utc), ' - UTC'),
#                     caption='Data source: HitBTC.com') + 
#                stat_smooth() + 
#                theme_economist() +
#                xlab('Date Time Collected (UTC)') +
#                ylab('Reported Volume (24 hour period)') +
#                transition_states(symbol) +
#                ggtitle('{closest_state} Reported Volume ($) Past 7 Days') +
#                view_follow(),fps=1)

# Delete animation before making new one
#file_delete('crypto_volume.gif')

# Save gif
#image_write(anim, path='crypto_volume.gif')


# Make gganimated plot of GitHub Stars:
#anim <- animate(ggplot(data = hitBTC_7,
#               aes(x = as.POSIXct(date_time_utc), y = Git_Stars, group = symbol)) + 
#                geom_point() +
#                labs(subtitle=paste('Latest data collected on:', max(hitBTC_7$date_time_utc), ' - UTC'),
#                     caption='Data source: HitBTC.com') + 
#                stat_smooth() + 
#                theme_economist() +
#                xlab('Date Time Collected (UTC)') +
#                ylab('GitHub Stars') +
#                transition_states(symbol) +
#                ggtitle('{closest_state} - GitHub Stars - Past 7 Days') +
#                view_follow(),fps=1)

# Delete animation before making new one
#file_delete('crypto_git_stars.gif')

# Save gif
#image_write(anim, path='crypto_git_stars.gif')

# Make gganimated plot of active addresses:
#anim <- animate(ggplot(data = hitBTC_7,
#               aes(x = as.POSIXct(date_time_utc), y = ActiveAddresses, group = symbol)) + 
#                geom_point() +
#                labs(subtitle=paste('Latest data collected on:', max(hitBTC_7$date_time_utc), ' - UTC'),
#                     caption='Data source: HitBTC.com') + 
#                stat_smooth() + 
#                theme_economist() +
#                xlab('Date Time Collected (UTC)') +
#                ylab('Active Addresses') +
#                transition_states(symbol) +
#                ggtitle('{closest_state} - Number of Active Addresses - Past 7 Days') +
#                view_follow(),fps=1)

# Delete animation before making new one
#file_delete('crypto_addresses.gif')

# Save gif
#image_write(anim, path='crypto_addresses.gif')
