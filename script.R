library(PredictCrypto)
library(ggplot2)
library(anytime)

# Pull Messari data:
messari <- get_crypto_data()

# Subset to ETH data:
eth_data <- subset(messari, Name == 'Ethereum')

# Convert date/time
messari$DateTimeColoradoMST <- anytime(messari$DateTimeColoradoMST)

# Make ggplot of ETH data:
ggplot(data = eth_data,
       aes(x = DateTimeColoradoMST, y = PriceUSD)) + 
       geom_line()
# Save png
ggsave('eth_plot.png')
