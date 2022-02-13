//
//  NewsItemViewModel.swift
//  CryptoList
//
//  Created by Ihwan on 13/02/22.
//

import Foundation

struct NewsItemViewModel {
    let source: String
    let title: String
    let body: String
}

extension NewsItemViewModel {
    init(news: News) {
        source = news.source.capitalizingFirstLetter()
        title = news.title
        body = news.body
    }
}
