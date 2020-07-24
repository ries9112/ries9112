library(PredictCrypto)
library(ggplot2)
library(anytime)
library(ggthemes)
library(fs)
library(gganimate)
library(magick)

# NOTE 07/23 BEFORE BED: DON'T COMMIT
# - DON'T COMMIT BECAUSE MOVING AWAY FROM STATIC 1 CRYPTO PHOTO, TO NEW SYSTEM
#WHERE TAKE TOP 20 RANKED AND TAKE LAST 14 DAYS, AND MAKE IT INTO GIF/VIDEO USING
#GGANIMATE. STILL WORKING ON GETTING THIS TO WORK THOUGH, SO UNTIL THEN,
#DO NOT COMMIT!

# Pull Messari data:
messari <- get_crypto_data()

# Filter data to top 50 ranked cryptos
messari <- subset(messari, Rank < 20)

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
                ggtitle('{closest_state} Price USD Last 31 Days') +
                view_follow(),fps=1)

# Delete image before making new one
file_delete('crypto_plot.gif')

# Save gif
image_write(anim, path='crypto_plot.gif')
