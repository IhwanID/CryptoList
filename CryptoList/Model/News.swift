//
//  News.swift
//  CryptoList
//
//  Created by Ihwan on 12/02/22.
//

import Foundation

struct News {
    let source: String
    let title: String
    let body: String
    let url: String
}

extension News: Equatable {}
