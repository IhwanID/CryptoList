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
    
    var subs: String {
        "2~Coinbase~\(symbol)~USD"
    }
}
