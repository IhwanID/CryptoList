//
//  RemoteNewsResponse.swift
//  CryptoList
//
//  Created by Ihwan on 12/02/22.
//

import Foundation

struct NewsRootResponse: Codable {
    let data: [NewsResponse]
    
    private enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
    
    var news : [News] {
        data.map{ News(source: $0.source, title: $0.title, body: $0.body)}
    }
}

struct NewsResponse: Codable {
    let title: String
    let source: String
    let body: String
}
