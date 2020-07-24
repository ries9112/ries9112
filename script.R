library(PredictCrypto)
library(ggplot2)
library(anytime)

# Pull Messari data:
messari_data <- get_crypto_data()

# Subset to ETH data:
eth_data <- subset(messari, Name == 'Ethereum')

# Convert date/time
messari$DateTimeColoradoMST <- anytime(messari$DateTimeColoradoMST)

# Make ggplot of ETH data:
ggplot(data = eth_data,
       aes(x = date_time_colorado_mst, y = sell_price_high_bid)) + 
       geom_line()
# Save png
ggsave('eth_plot.png')
