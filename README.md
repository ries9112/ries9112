## Hi there 👋

(I need to update this 😅)

### My name is Riccardo but I go by Ricky. I love <img src="https://raw.githubusercontent.com/github/explore/80688e429a7d4ef2fca1e82350fe8e3517d3494d/topics/r/r.png" data-canonical-src="https://raw.githubusercontent.com/github/explore/80688e429a7d4ef2fca1e82350fe8e3517d3494d/topics/r/r.png" width="30" height="28" /> and data automation. This document gets updated hourly.

[![Linkedin](https://img.shields.io/badge/-Riccardo_Esclapon-blue?style=flat-square&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/esclaponriccardo/)](https://www.linkedin.com/in/esclaponriccardo/)

### Below is an animated GIF showing cryptocurrency prices for the past 31 days, powered by GitHub Actions and R, which updates once every hour (check the timestamp on the latest data in the subtitle of the chart below - UTC timezone):

<img src="https://github.com/ries9112/ries9112/blob/master/crypto_plot.gif" width="450">   

The past 31 days of data are being shown, and the data and GIF shown updates hourly.

###### [data source: HitBTC Orderbooks](https://hitbtc.com/btc-to-usd)

You can download the latest your data yourself by running the following code in R:
```R
install.packages('pins') # only run this if 'pins' package is not already installed
# Load required package
library(pins)
# Point to the correct board
board_register(name = "pins_board", 
                url = "https://raw.githubusercontent.com/predictcrypto/pins/master/", 
              board = "datatxt")
# Pull the data
cryptodata <- pin_get(board = "pins_board", name = "hitBTC_orderbook")
# Show the data
cryptodata
```
No authentication or anything else is required outside of running the code above to pull the data, which is updated once every hour.


### [Click here to access interactive tutorials which use cryptocurrency data that refreshes hourly](https://predictcrypto.org/tutorials)

## Press on the button below to show the rest of this document:
<details>
  <summary> <b> Show the rest of the page </b>
<p style="font-size:30px">
</p> </summary>  

### Ethereum Price Trend:

<img src="https://github.com/ries9112/ries9112/blob/master/Ethereum.png" width="450">   

*Points are colored in green if the latest price is higher than two days ago, and red if it is lower than two days ago.*

### Now only showing the last 2 days:

<img src="https://github.com/ries9112/ries9112/blob/master/crypto_plot_2.gif" width="450">   

![Ricky Github Stats](https://github-readme-stats.vercel.app/api?username=ries9112&show_icons=true&title_color=fff&icon_color=79ff97&text_color=9f9f9f&bg_color=151515)

### Some of My Favorite R Resources: https://www.notion.so/Programming-Resources-cf8986603ddc4968bbc8f7e835430b89

### How do you add a page like this to your own GitHub profile?

###### [Original tweet by Simon Willison](https://twitter.com/simonw/status/1281435464474324993)

###### [Original blog post by Simon Willison](https://simonwillison.net/2020/Jul/10/self-updating-profile-readme/)

###### [R Adaptation by Zhi Yang](https://twitter.com/zhiiiyang/status/1281996703839608833)

Be sure to create a new repository named the same as your GitHub username with a readme.md in order to get this to appear on your profile, forking this or a different repository will not work. [Click here for some great templates](https://github.com/kautukkundan/Awesome-Profile-README-templates).


<!--
### Click below for more cryptocurrency charts, which refresh hourly:  
<details>  
  <summary> <b> Click here for more plots: </b> 
<p align="center">  
</p> </summary>    


### Last 7 Days - Reported 24 Hour Volume
<img src="https://github.com/ries9112/ries9112/blob/master/crypto_volume.gif" width="450">

### Last 7 Days - GitHub Stars
<img src="https://github.com/ries9112/ries9112/blob/master/crypto_git_stars.gif" width="450">

### Last 7 Days - Active Addresses
<img src="https://github.com/ries9112/ries9112/blob/master/crypto_addresses.gif" width="450">

###### Data plotted above should never be outdated by more than 2 hours

-->
