[![IDE](https://img.shields.io/badge/Xcode-13.2.1-blue.svg)](https://developer.apple.com/xcode/)
[![Platform](https://img.shields.io/badge/iOS-15.2-green.svg)](https://developer.apple.com/ios/)
[![Build Status](https://github.com/IhwanID/CryptoList/actions/workflows/CryptoList.yml/badge.svg)](https://github.com/IhwanID/CryptoList/actions/workflows/CryptoList.yml)

# CryptoList

iOS App that show live update cryptocurrency price with current news.

## Requirement:
- [x] Display a list of at least 50 tickers
- [x] Display news related to the currency selected upon tapping a cell
- [x] Show live price updates using Web Socket
- [x] Pull to refresh from the Toplist
- [x] Show the correct ticker color
- [x] Handle network errors


## Solution:
- Using URLSession for load data coin and news
- Using URLSessionWebSocketTask for load live price updates from Websocket

## What else could be done with more time:
- Proper Unit Testing & Good Code Coverage (in research)
- Unit Testing for WebSocket layer (in research)
- Generic in Unit Testing (Reusable Testing)
- Modularize Networking Layer to Static Framework (Agnostic Target)

