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
    
    mutating func update(with new: NewCoinPrice) {
        if new.symbol == symbol {
            self = Coin(name: name, symbol: symbol, price: new.price, open24Hour: open24Hour)
        }
    }
}

extension Coin: Equatable {}
