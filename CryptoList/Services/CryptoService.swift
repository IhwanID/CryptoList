//
//  CryptoService.swift
//  CryptoList
//
//  Created by Ihwan on 11/02/22.
//

import Foundation

protocol CryptoService {
    func loadCrypto(limit: UInt, completion: @escaping (Result<[Coin], Error>) -> Void)
}

class CryptoServiceAPI: CryptoService {
    func loadCrypto(limit: UInt, completion: @escaping (Result<[Coin], Error>) -> Void) {
        let url = URL(string: "https://min-api.cryptocompare.com/data/top/totaltoptiervolfull?limit=\(limit)&tsym=USD")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            do {
                let coinData = try JSONDecoder().decode(CoinRootResponse.self, from: data)
                completion(.success(coinData.coins))
            } catch let error {
                completion(.failure(error))
            }
        }
        
        task.resume()
        
    }
}

