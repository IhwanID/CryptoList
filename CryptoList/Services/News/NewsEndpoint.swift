//
//  NewsEndpoint.swift
//  CryptoList
//
//  Created by Ihwan on 13/02/22.
//

import Foundation

public enum NewsEndpoint {
    
    case get(category: String)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(category):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/data/v2/news/"
            components.queryItems = [
                URLQueryItem(name: "lang", value: "EN"),
                URLQueryItem(name: "categories", value: category)
            ].compactMap { $0 }
            return components.url!
        }
    }
}
