library(PredictCrypto)
library(ggplot2)
library(anytime)

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
       labs(title='Ethereum Price Over Time',
            subtitle=paste('Latest data from:', max(eth_data$DateTimeColoradoMST))
# Save png
ggsave('eth_plot.png')
