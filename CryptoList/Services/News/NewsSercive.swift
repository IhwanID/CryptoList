//
//  NewsSercive.swift
//  CryptoList
//
//  Created by Ihwan on 12/02/22.
//

import Foundation

protocol NewsService {
    func loadNews(categories: String, completion: @escaping (Result<[News], Error>) -> Void)
}

class NewsServiceAPI: NewsService {
    func loadNews(categories: String, completion: @escaping (Result<[News], Error>) -> Void) {
        let url = URL(string: "https://min-api.cryptocompare.com/data/v2/news/?lang=EN&categories=\(categories)")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            do {
                let newsData = try JSONDecoder().decode(NewsRootResponse.self, from: data)
                completion(.success(newsData.news))
            } catch let error {
                completion(.failure(error))
            }
        }
        
        task.resume()
        
    }
}
