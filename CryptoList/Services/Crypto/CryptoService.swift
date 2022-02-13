//
//  CryptoService.swift
//  CryptoList
//
//  Created by Ihwan on 11/02/22.
//

import Foundation

protocol CryptoService {
    typealias Result = Swift.Result<[Coin], Error>
    
    func loadCrypto(limit: UInt, completion: @escaping (Result) -> Void)
}

class CryptoServiceAPI: CryptoService {
    
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
    
    func loadCrypto(limit: UInt, completion: @escaping (CryptoService.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(CryptoMapper.map(data: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

