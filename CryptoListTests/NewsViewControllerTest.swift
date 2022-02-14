//
//  NewsViewControllerTest.swift
//  CryptoListTests
//
//  Created by Ihwan on 13/02/22.
//

import XCTest
@testable import CryptoList

class NewsViewControllerTests: XCTestCase {
    func test_canInit() throws {
        _ = try makeSUT()
    }
    
    func test_viewDidLoad_setsTitle() throws {
        let sut = try makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, "News")
    }
    
    
    func test_viewDidLoad_initialState() throws {
        let sut = try makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfNews(), 0)
    }
    
    func test_viewDidLoad_doesNotLoadNewsFromAPI() throws {
        let service = NewsServiceSpy()
        let sut = try makeSUT()
        sut.service = service
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(service.loadNewsCount, 0)
    }
    
    func test_viewWillAppear_loadNewsFromAPI() throws {
        let service = NewsServiceSpy()
        let sut = try makeSUT()
        sut.service = service
        
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(service.loadNewsCount, 1)
    }
    
    func test_viewDidLoad_rendersNews() throws {
        let sut = try makeSUT()
        
        sut.service = NewsServiceSpy(result: [makeNews(source: "a Source", title: "A News Title", body: "A Body News")])
        
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(sut.numberOfNews(), 1)
        XCTAssertEqual(sut.source(atRow: 0), "A Source")
        XCTAssertEqual(sut.title(atRow: 0), "A News Title")
        XCTAssertEqual(sut.body(atRow: 0), "A Body News")
        
    }
    
    func makeSUT() throws -> NewsViewController {
        let bundle = Bundle(for: NewsViewController.self)
        let sb = UIStoryboard(name: "Main", bundle: bundle)
        
        let initialVC = sb.instantiateViewController(withIdentifier: "newsVC")
        let sut = try XCTUnwrap(initialVC as? NewsViewController)
        return sut
    }
}

private func makeNews(source: String, title: String, body: String) -> News {
    News(source: source, title: title, body: body)
}

extension NewsViewController {
    func numberOfNews() -> Int {
        tableView.numberOfRows(inSection: newsSection)
    }
    
    func source(atRow row: Int) -> String? {
        newsCell(atRow: row)?.sourceLabel.text
    }
    
    func title(atRow row: Int) -> String? {
        newsCell(atRow: row)?.titleLabel.text
    }
    
    func body(atRow row: Int) -> String? {
        newsCell(atRow: row)?.bodyLabel.text
    }
    
    func newsCell(atRow row: Int) -> NewsCell? {
        let ds = tableView.dataSource
        let indexPath = IndexPath(row: row, section: newsSection)
        return ds?.tableView(tableView, cellForRowAt: indexPath) as? NewsCell
    }
    
    private var newsSection: Int { 0 }
    
}
