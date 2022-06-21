[![IDE](https://img.shields.io/badge/Xcode-13.2.1-blue.svg)](https://developer.apple.com/xcode/)
[![Platform](https://img.shields.io/badge/iOS-15.2-green.svg)](https://developer.apple.com/ios/)
[![Build Status](https://github.com/IhwanID/CryptoList/actions/workflows/CryptoList.yml/badge.svg)](https://github.com/IhwanID/CryptoList/actions/workflows/CryptoList.yml)

# CryptoList

iOS App that displays live price updates list of most active cryptocurrencies with current news.

## Screenshot
![home](screenshot/home.png "Home Screen")
![news](screenshot/news.png "News Feature")

## Requirement:
- [x] Display a list of at least 50 tickers
- [x] Display news related to the currency selected upon tapping a cell
- [x] Show live price updates using Web Socket
- [x] Pull to refresh from the Toplist
- [x] Show the correct ticker color (green when the price increases and red for the opposite)
- [x] Handle network errors

## Solution:
- Using URLSession for load data coin and news
- Using URLSessionWebSocketTask for load live price updates from Websocket

## TODO:
- Unit Testing for WebSocket layer (in research)
- Generic in Unit Testing (Reusable Testing)

## How to install :
- Make sure you have Xcode 13.2.1 or above
- Open CryptoList.xcodeproj
- Run unit testing using `cmd + U`
- Run project to simulator or real device using `cmd + R`
