//
//  NewCoinPriceMapper.swift
//  CryptoList
//
//  Created by Ihwan on 03/01/23.
//

import Foundation

enum NewCoinPriceMapper {
    
    private struct Response: Decodable {
        let PRICE: Double
        let FROMSYMBOL: String
    }
    
    static func map(_ data: Data) throws -> NewCoinPrice? {
        let response = try JSONDecoder().decode(Response.self, from:  data)
        return NewCoinPrice(price: response.PRICE, symbol: response.FROMSYMBOL)
    }
}
