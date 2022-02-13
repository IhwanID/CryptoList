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
        bgColor = diffPrice.sign == .minus ? .init(red: 255.0/255.0, green: 52.0/255.0, blue: 42.0/255.0, alpha: 1) : .init(red: 46.0/255.0, green: 192.0/255.0, blue: 79.0/255.0, alpha: 1)
    }
}
