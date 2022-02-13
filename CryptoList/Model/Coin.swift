//
//  Coin.swift
//  CryptoList
//
//  Created by Ihwan on 11/02/22.
//

import Foundation

struct Coin {
    let name: String
    let symbol: String
    let price: Double
    let open24Hour: Double
    
    var subs: String {
        "2~Binance~\(symbol)~USDT"
    }
}
