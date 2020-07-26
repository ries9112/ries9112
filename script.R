library(PredictCrypto)
library(ggplot2)
library(anytime)
library(ggthemes)
library(fs)
library(gganimate)
library(magick)

# Pull Messari data:
messari <- get_crypto_data()

# Filter data to top 20 ranked cryptos
messari <- subset(messari, Rank < 20)

# Remove USD coins:
#messari <- subset(messari, Name != c(messari$Name[!grepl("USD", messari$Name)]))

# Convert date/time
messari$DateTimeColoradoMST <- as.POSIXct(messari$DateTimeColoradoMST, format="%Y-%m-%d %H:%M:%S")

# Filter data to last 31 days
messari <- subset(messari, DateTimeColoradoMST > Sys.time()-60*60*24*31)

# Make gganimated plot:
anim <- animate(ggplot(data = messari,
               aes(x = as.POSIXct(DateTimeColoradoMST), y = PriceUSD, group = Name)) + 
                geom_line() +
                labs(subtitle=paste('Latest data collected on:', max(messari$DateTimeColoradoMST), ' - MST'),
                     caption='Data source: messari.io') + 
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
messari_2 <- subset(messari, DateTimeColoradoMST > Sys.time()-60*60*24*2)

# Make gganimated plot:
anim <- animate(ggplot(data = messari_2,
               aes(x = as.POSIXct(DateTimeColoradoMST), y = PriceUSD, group = Name)) + 
                geom_point() +
                labs(subtitle=paste('Latest data collected on:', max(messari_2$DateTimeColoradoMST), ' - MST'),
                     caption='Data source: messari.io') + 
                stat_smooth() + 
                theme_economist() +
                xlab('Date Time Collected (Colorado - MST)') +
                ylab('Price USD ($)') +
                transition_states(Name) +
                ggtitle('{closest_state} Price ($) Past 2 Days') +
                view_follow(),fps=1)

# Delete animation before making new one
file_delete('crypto_plot_2.gif')

# Save gif
image_write(anim, path='crypto_plot_2.gif')

# Make more charts
# Filter to last 7 days
messari_7 <- subset(messari, DateTimeColoradoMST > Sys.time()-60*60*24*7)

# Make gganimated plot of reported 24h volume:
anim <- animate(ggplot(data = messari_7,
               aes(x = as.POSIXct(DateTimeColoradoMST), y = Reported24hVolume, group = Name)) + 
                geom_point() +
                labs(subtitle=paste('Latest data collected on:', max(messari_7$DateTimeColoradoMST), ' - MST'),
                     caption='Data source: messari.io') + 
                stat_smooth() + 
                theme_economist() +
                xlab('Date Time Collected (Colorado - MST)') +
                ylab('Reported Volume (24 hour period)') +
                transition_states(Name) +
                ggtitle('{closest_state} Reported Volume ($) Past 7 Days') +
                view_follow(),fps=1)

# Delete animation before making new one
file_delete('crypto_volume.gif')

# Save gif
image_write(anim, path='crypto_volume.gif')


# Make gganimated plot of GitHub Stars:
anim <- animate(ggplot(data = messari_7,
               aes(x = as.POSIXct(DateTimeColoradoMST), y = Git_Stars, group = Name)) + 
                geom_point() +
                labs(subtitle=paste('Latest data collected on:', max(messari_7$DateTimeColoradoMST), ' - MST'),
                     caption='Data source: messari.io') + 
                stat_smooth() + 
                theme_economist() +
                xlab('Date Time Collected (Colorado - MST)') +
                ylab('GitHub Stars') +
                transition_states(Name) +
                ggtitle('{closest_state} - GitHub Stars - Past 7 Days') +
                view_follow(),fps=1)

# Delete animation before making new one
file_delete('crypto_git_stars.gif')

# Save gif
image_write(anim, path='crypto_git_stars.gif')

# Make gganimated plot of active addresses:
anim <- animate(ggplot(data = messari_7,
               aes(x = as.POSIXct(DateTimeColoradoMST), y = ActiveAddresses, group = Name)) + 
                geom_point() +
                labs(subtitle=paste('Latest data collected on:', max(messari_7$DateTimeColoradoMST), ' - MST'),
                     caption='Data source: messari.io') + 
                stat_smooth() + 
                theme_economist() +
                xlab('Date Time Collected (Colorado - MST)') +
                ylab('Active Addresses') +
                transition_states(Name) +
                ggtitle('{closest_state} - Number of Active Addresses - Past 7 Days') +
                view_follow(),fps=1)

# Delete animation before making new one
file_delete('crypto_addresses.gif')

# Save gif
image_write(anim, path='crypto_addresses.gif')
