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

# Make gganimated plot of ETH data:
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
messari <- subset(messari, DateTimeColoradoMST > Sys.time()-60*60*24*2)

# Make gganimated plot of ETH data:
anim <- animate(ggplot(data = messari,
               aes(x = as.POSIXct(DateTimeColoradoMST), y = PriceUSD, group = Name)) + 
                geom_point() +
                labs(subtitle=paste('Latest data collected on:', max(messari$DateTimeColoradoMST), ' - MST'),
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
