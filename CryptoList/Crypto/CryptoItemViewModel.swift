//
//  CryptoItemViewModel.swift
//  CryptoList
//
//  Created by Ihwan on 13/02/22.
//

import Foundation
import UIKit

struct CryptoItemViewModel {
    let name: String
    let symbol: String
    let price: String
    let ticker: String
    let bgColor: UIColor
}

extension CryptoItemViewModel {
    init(coin: Coin, livePrice: Double){
        
        let currentPrice = coin.open24Hour
        
        let diffPrice: Double = livePrice - currentPrice
        let percentage = (diffPrice/livePrice)
        name = coin.name
        symbol = coin.symbol
        price = "\(livePrice.currencyFormat)"
        ticker = "\(diffPrice.diffFomat)(\(percentage.percentageFormat))"
        bgColor = diffPrice.sign == .minus ? .systemRed : .systemGreen
    }
}
