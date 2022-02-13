//
//  NewsService.swift
//  CryptoList
//
//  Created by Ihwan on 12/02/22.
//

import Foundation

protocol NewsService {
    typealias Result = Swift.Result<[News], Error>
    
    func load(completion: @escaping (Result) -> Void)
}

class NewsServiceAPI: NewsService {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (NewsService.Result) -> Void) {
        
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(NewsMapper.map(data: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
