[![IDE](https://img.shields.io/badge/Xcode-13.2.1-blue.svg)](https://developer.apple.com/xcode/)
[![Platform](https://img.shields.io/badge/iOS-15.2-green.svg)](https://developer.apple.com/ios/)
[![Build Status](https://github.com/IhwanID/CryptoList/actions/workflows/CryptoList.yml/badge.svg)](https://github.com/IhwanID/CryptoList/actions/workflows/CryptoList.yml)

# CryptoList

## iOS App that displays live price updates list of most active cryptocurrencies with current news.

### Story: User requests to see list of most active cryptocurrencies with live price updates

### Narrative #1

```
As an online user
I want the app to automatically load list of most active cryptocurrencies with live price updates
So I can always enjoy the newest price of list cryptocurrencies
```

#### Scenarios (Acceptance criteria)

```
Given the user has connectivity
When the user requests to see list of most active cryptocurrencies
Then the app should display list of most active cryptocurrencies with live price updates from remote
```

#### Requirement:

- [x] Display a list of at least 50 tickers
- [x] Display news related to the currency selected upon tapping a cell
- [x] Show live price updates using Web Socket
- [x] Pull to refresh from the CryptoList
- [x] Show the correct ticker color (green when the price increases and red for the opposite)
- [x] Handle network errors

#### Solution:

- Using URLSession for load data coin and news
- Using URLSessionWebSocketTask for load live price updates from Websocket

## TODO:
- Decouple WebSocket
- Unit Testing for WebSocket layer

## How to install :
- Make sure you have Xcode 13.2.1 or above
- Open CryptoList.xcodeproj
- Run unit testing using `cmd + U`
- Run project to simulator or real device using `cmd + R`
