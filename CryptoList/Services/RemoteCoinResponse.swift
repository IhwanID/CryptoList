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
        data.map{ Coin(name: $0.coinInfo.fullName, symbol: $0.coinInfo.name)}
    }
}

struct CoinResponse: Codable{
    let coinInfo: CoinInfo
    
    private enum CodingKeys : String, CodingKey {
        case coinInfo = "CoinInfo"
    }
}

struct CoinInfo: Codable{
    let name: String
    let fullName: String
    
    private enum CodingKeys : String, CodingKey {
        case name = "Name", fullName = "FullName"
    }
    
}
