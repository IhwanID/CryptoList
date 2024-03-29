//
//  CryptoListViewControllerTests.swift
//  CryptoListTests
//
//  Created by Ihwan on 13/02/22.
//

import XCTest
@testable import CryptoList

class CryptoListViewControllerTests: XCTestCase {
    func test_canInit() throws {
        _ = try makeSUT()
    }
    
    func test_viewDidLoad_setsTitle() throws {
        let sut = try makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, "CryptoList")
    }
    
    
    func test_viewDidLoad_initialState() throws {
        let sut = try makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfCoin(), 0)
    }
    
    func test_viewDidLoad_doesNotLoadCryptoFromAPI() throws {
        let service = CryptoServiceSpy()
        let sut = try makeSUT()
        sut.viewModel = CryptoListViewModel(service: service)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(service.loadCryptoCount, 0)
    }
    
    func test_viewWillAppear_loadCoinsFromAPI() throws {
        let service = CryptoServiceSpy()
        let sut = try makeSUT()
        sut.viewModel = CryptoListViewModel(service: service)
        
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(service.loadCryptoCount, 1)
    }
    
    func test_viewDidLoad_rendersCoins() throws {
        let sut = try makeSUT()
        let service = CryptoServiceSpy(result: [makeCoin(name: "Bitcoin", symbol: "BTC", price: 100)])
        sut.viewModel = CryptoListViewModel(service: service)
        
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(sut.numberOfCoin(), 1)
        XCTAssertEqual(sut.name(atRow: 0), "Bitcoin")
        XCTAssertEqual(sut.symbol(atRow: 0), "BTC")
        XCTAssertEqual(sut.price(atRow: 0), "$100.00")
        
    }
    
    func test_coinUpdated_updateCoinCell() throws {
        let sut = try makeSUT()
        let service = CryptoServiceSpy(result: [makeCoin(name: "Bitcoin", symbol: "BTC", price: 100)])
        sut.viewModel = CryptoListViewModel(service: service)
        
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        sut.didReceive(newCoinPrice: NewCoinPrice(price: 110, symbol: "BTC"))
        
        XCTAssertEqual(sut.numberOfCoin(), 1)
        XCTAssertEqual(sut.name(atRow: 0), "Bitcoin")
        XCTAssertEqual(sut.symbol(atRow: 0), "BTC")
        XCTAssertEqual(sut.price(atRow: 0), "$110.00")
        
    }
    
    func test_viewWillAppear_failedAPIResponse_showsError() throws {
        let service = CryptoServiceSpy(result: AnyError(errorDescription: "Error: Failed API Response"))
        let sut = try makeTestableSUT()
        sut.viewModel = CryptoListViewModel(service: service)
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(sut.errorMessage(), "Error: Failed API Response")
    }
    
    
    func makeSUT() throws -> CryptoListViewController {
        let bundle = Bundle(for: CryptoListViewController.self)
        let sb = UIStoryboard(name: "Main", bundle: bundle)
        
        let initialVC = sb.instantiateInitialViewController()
        let sut = try XCTUnwrap(initialVC as? CryptoListViewController)
        return sut
    }
    
    func makeTestableSUT() throws -> TestableCryptoListViewController {
        let bundle = Bundle(for: CryptoListViewController.self)
        let sb = UIStoryboard(name: "Main", bundle: bundle)
        
        let initialVC = sb.instantiateInitialViewController { coder in
            return TestableCryptoListViewController(coder: coder)
        }
        let sut = try XCTUnwrap(initialVC)
        return sut
    }
}

struct AnyError: LocalizedError {
    var errorDescription: String?
}

private func makeCoin(name: String, symbol: String, price: Double) -> Coin {
    Coin(name: name, symbol: symbol, price: price, open24Hour: 0)
}

extension CryptoListViewController {
    func numberOfCoin() -> Int {
        tableView.numberOfRows(inSection: coinSection)
    }
    
    func name(atRow row: Int) -> String? {
        cryptoCell(atRow: row)?.coinNameLabel.text
    }
    
    func symbol(atRow row: Int) -> String? {
        cryptoCell(atRow: row)?.coinSymbolLabel.text
    }
    
    func price(atRow row: Int) -> String? {
        cryptoCell(atRow: row)?.priceLabel.text
    }
    
    
    func cryptoCell(atRow row: Int) -> CryptoCell? {
        let ds = tableView.dataSource
        let indexPath = IndexPath(row: row, section: coinSection)
        return ds?.tableView(tableView, cellForRowAt: indexPath) as? CryptoCell
    }
    
    private var coinSection: Int { 0 }
    
}

class TestableCryptoListViewController: CryptoListViewController {
    var presentedVC: UIViewController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedVC = viewControllerToPresent
    }
    
    func errorMessage() -> String? {
        let alert = presentedVC as? UIAlertController
        return alert?.message
    }
}
