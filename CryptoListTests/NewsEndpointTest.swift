//
//  NewsEndpointTest.swift
//  CryptoListTests
//
//  Created by Ihwan on 16/02/22.
//

import XCTest
import CryptoList

class NewsEndpointTest: XCTestCase {

    func test_news_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = NewsEndpoint.get(category: "BTC").url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/data/v2/news", "path")
        XCTAssertEqual(received.query?.contains("lang=EN"), true, "default language param")
        XCTAssertEqual(received.query?.contains("categories=BTC"), true, "category param")
    }

}
