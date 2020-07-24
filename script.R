library(PredictCrypto)
library(ggplot2)
library(anytime)
library(ggthemes)
library(fs)

# Pull Messari data:
messari <- get_crypto_data()

# Subset to ETH data:
eth_data <- subset(messari, Name == 'Ethereum')

# Convert date/time
eth_data$DateTimeColoradoMST <- anytime(eth_data$DateTimeColoradoMST)

# Make ggplot of ETH data:
ggplot(data = eth_data,
       aes(x = DateTimeColoradoMST, y = PriceUSD)) + 
       geom_line() +
       labs(title='Ethereum (ETH) Price Over Time',
            subtitle=paste('Latest data from:', max(eth_data$DateTimeColoradoMST), ' - MST'),
            caption='Data source: messari.io') + 
       stat_smooth() + 
       theme_economist() +
       xlab('Date Time Collected (Colorado - MST)') +
       ylab('Price USD ($)')

# Delete image before making new one
file_delete('eth_plot.png')

# Save png
ggsave('eth_plot.png')
