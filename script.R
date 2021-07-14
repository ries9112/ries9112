library(pacman)
# Load packages
p_load('pins','ggplot2','anytime','ggthemes','fs','gganimate','magick','dplyr','transformr', 'ggforce')

# Register Board for data pull
board_register("https://raw.githubusercontent.com/predictcrypto/pins/master/","hitBTC_orderbooks_github")

# Pull data
hitBTC <- pin_get("hitBTC_orderbooks_github", "hitBTC_orderbooks_github")

# Unique data
hitBTC <- distinct(hitBTC, pkey, .keep_all = T)

# Remove unwanted symbols (USD indexes)
hitBTC <- filter(hitBTC, symbol != 'LEO')

# Convert date/time
hitBTC$date_time_utc <- as.POSIXct(hitBTC$date_time_utc, format="%Y-%m-%d %H:%M:%S")

# Filter data to last 31 days
hitBTC <- subset(hitBTC, date_time_utc > Sys.time()-60*60*24*31)

# Rename price field
hitBTC <- rename(hitBTC, PriceUSD = 'bid_1_price')

# Adjust PriceUSD to be numeric
hitBTC$PriceUSD <- as.numeric(hitBTC$PriceUSD)

# Remove symbols where we would expect more data points
hitBTC <- dplyr::filter(group_by(hitBTC, symbol), n() >= 500)

# Make gganimated plot:
anim <- animate(ggplot(data = hitBTC,
               aes(x = as.POSIXct(date_time_utc), y = PriceUSD, group = symbol)) + 
                geom_line() +
                labs(subtitle=paste('Latest data collected on:', max(hitBTC$date_time_utc), ' - UTC'),
                     caption='Data source: HitBTC API') + 
                stat_smooth() + 
                theme_economist() +
                xlab('Date Time Collected (UTC)') +
                ylab('Price USD ($)') +
                transition_states(symbol) +
                ggtitle(paste('{closest_state} Price ($) Past 31 Days -', toString(Sys.Date()), '(UTC)')) +
                view_follow(),fps=2)

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
               geom_line() +
               geom_point() +
               labs(subtitle=paste('Latest data collected on:', max(hitBTC_2$date_time_utc), ' - UTC'),
                    caption='Data source: HitBTC API') + 
               theme_economist() +
               xlab('Date Time Collected (UTC)') +
               ylab('Price USD ($)') +
               transition_states(symbol) +
               ggtitle(paste('{closest_state} Price ($) Past 2 Days -', toString(Sys.Date()), '(UTC)')) +
               view_follow(),fps=2)

# Delete animation before making new one
file_delete('crypto_plot_2.gif')

# Save gif
image_write(anim, path='crypto_plot_2.gif')

# Make ETH specific chart
eth_data = filter(hitBTC, symbol=='ETH')
# Ethereum Price - green when positive trend in last 2 days - red when negative trend in last 2 days
if (eth_data[eth_data$date_time_utc == max(eth_data$date_time_utc, na.rm=T),]$ask_1_price > eth_data[eth_data$date_time_utc == min(filter(hitBTC_2,symbol=='ETH')$date_time_utc, na.rm=T),]$ask_1_price){
  ggplot(data = eth_data,
         aes(x = as.POSIXct(date_time_utc), y = PriceUSD, group = symbol)) + 
    geom_line(size=1.2) +
    geom_point(size=0.7, color='dark green') +
    labs(subtitle=paste('Latest data collected on:', max(hitBTC$date_time_utc), ' - UTC'),
         caption='Data source: HitBTC API') + 
    #geom_mark_ellipse(aes(filter = ask_1_price == max(ask_1_price),
    #                      label = date_time_utc,
    #                      description = paste0('Price spike to $', ask_1_price))) +
    # Now the same to circle the minimum price:
    #geom_mark_ellipse(aes(filter = ask_1_price == min(ask_1_price),
    #                      label = date_time_utc,
    #                      description = paste0('Price drop to $', ask_1_price))) +
    theme_economist() +
    xlab('Date Time Collected (UTC)') +
    ylab('Price USD ($)') +
    ggtitle(paste('Ethereum Price ($) - Past 31 Days - Hourly')) 
} else if (eth_data[eth_data$date_time_utc == max(eth_data$date_time_utc, na.rm=T),]$ask_1_price < eth_data[eth_data$date_time_utc == min(filter(hitBTC_2,symbol=='ETH')$date_time_utc, na.rm=T),]$ask_1_price){
    
    ggplot(data = eth_data,
           aes(x = as.POSIXct(date_time_utc), y = PriceUSD, group = symbol)) + 
      geom_line(size=1.2) +
      geom_point(size=0.7, color='dark red') +
      labs(subtitle=paste('Latest data collected on:', max(eth_data$date_time_utc), ' - UTC'),
           caption='Data source: HitBTC API') + 
      
      #geom_mark_ellipse(aes(filter = ask_1_price == max(ask_1_price),
      #                      label = date_time_utc,
      #                      description = paste0('Price spike to $', ask_1_price))) +
      # Now the same to circle the minimum price:
      #geom_mark_ellipse(aes(filter = ask_1_price == min(ask_1_price),
      #                      label = date_time_utc,
      #                      description = paste0('Price drop to $', ask_1_price))) +
      theme_economist() +
      xlab('Date Time Collected (UTC)') +
      ylab('Price USD ($)') +
      ggtitle(paste('Ethereum Price ($) - Past 31 Days - Hourly')) 
}
# Save chart
ggsave('Ethereum.png')


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


# Update data for toggl (No need, made flexdashboard instead) 
#library(togglr)
#set_toggl_api_token(toString(Sys.getenv("TOGGL_API")))
# get data
#toggl_data <- get_time_entries()
# next add date/time
#toggl_data$DateTime <- Sys.time()
# read in csv data
#historical_toggl <- read.csv('toggl_data.csv')
# union to historical csv data
#toggl_data <- union(toggl_data, historical_toggl)
# write to csv file
#write.csv(toggl_data, 'toggl_data.csv')

# then write data to db + pin it (for good measure)

