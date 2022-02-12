//
//  CryptoService.swift
//  CryptoList
//
//  Created by Ihwan on 11/02/22.
//

import Foundation

enum NetworkError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
    case encodingError(Error)
}

protocol CryptoService {
    func loadCrypto(limit: UInt, completion: @escaping (Result<[Coin], NetworkError>) -> Void)
}

class CryptoServiceAPI: CryptoService {
    func loadCrypto(limit: UInt, completion: @escaping (Result<[Coin], NetworkError>) -> Void) {
        let key = "7b9eee5bd406bb262532c51c3665375786b10d5b45c17bf0772d687b15842111"
        let request = URLRequest(url: URL(string: "https://min-api.cryptocompare.com/data/top/totaltoptiervolfull?limit=\(limit)&tsym=USD&api_key=\(key)")!)
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(.failure(.serverError(statusCode: response.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                
                let coinData = try JSONDecoder().decode(CoinRootResponse.self, from: data)
                completion(.success(coinData.coins))
            } catch let error {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
        
    }
}

