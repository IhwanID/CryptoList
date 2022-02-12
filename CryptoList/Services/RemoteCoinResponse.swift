//
//  RemoteCoinResponse.swift
//  CryptoList
//
//  Created by Ihwan on 11/02/22.
//

import Foundation

struct CoinRootResponse: Decodable{
    let data: [CoinResponse]
    
    private enum CodingKeys : String, CodingKey {
        case data="Data"
    }
    
    var coins : [Coin] {
        data.map{ Coin(name: $0.coinInfo.fullName, symbol: $0.coinInfo.name, price: $0.raw?.usd.price ?? 0, open24Hour: $0.raw?.usd.open24Hour ?? 0)}
    }
}

struct CoinResponse: Codable {
    let coinInfo: CoinInfo
    let raw: Raw?
    
    private enum CodingKeys : String, CodingKey {
        case coinInfo = "CoinInfo", raw = "RAW"
    }
}

struct CoinInfo: Codable {
    let name: String
    let fullName: String
    
    private enum CodingKeys : String, CodingKey {
        case name = "Name", fullName = "FullName"
    }
}

struct Raw: Codable{
    let usd: USD
    
    private enum CodingKeys: String, CodingKey {
             case usd = "USD"
         }
}

struct USD: Codable {
    let price: Double
    let open24Hour: Double
    
    private enum CodingKeys: String, CodingKey {
            case price = "PRICE", open24Hour = "OPEN24HOUR"
         }
}
