//
//  SceneDelegate.swift
//  CryptoList
//
//  Created by Ihwan on 11/02/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var baseURL = URL(string: "https://min-api.cryptocompare.com")!
    
    private lazy var navigationController = UINavigationController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = navigationController
        navigationController.viewControllers = [makeCryptoListViewController()]
        window?.makeKeyAndVisible()
    }
    
    func makeCryptoListViewController() -> CryptoListViewController {
        let bundle = Bundle(for: CryptoListViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let vc = storyboard.instantiateInitialViewController() as! CryptoListViewController
        let vm = CryptoListViewModel(service: MainQueueDispatchDecorator(decoratee: CryptoServiceAPI(url: CryptoEndpoint.get(limit: 50).url(baseURL: baseURL), client: httpClient)))
        vc.viewModel = vm
        
        let url = URL(string: "wss://streamer.cryptocompare.com/v2?api_key=4c6ec4fa84b66963743a2a2ea291ec5e6216fe1c5453046f3b16c186878743b5")!
        let tracker = CoinWebSocketTracker(url: url, queue: .main)
        vc.viewIsReady = tracker.connect
        vm.add(coinsObserver: tracker.track)
        tracker.didReceiveNewCoinPrice = { [weak vc] newPrice in
                vc?.didReceive(newCoinPrice: newPrice)
        }
        
        let flow = NewsSelectionFlow(navigationController: navigationController, makeNewsViewController: makeNewsViewController(category:))
        vc.select = flow.showNews(forSymbol:)
        return vc
    }
    
    func makeNewsViewController(category: String) -> NewsViewController {
        let bundle = Bundle(for: NewsViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "newsVC") as! NewsViewController
        vc.viewModel = NewsViewModel(service: MainQueueDispatchDecorator(decoratee: NewsServiceAPI(url: NewsEndpoint.get(category: category).url(baseURL: baseURL), client: httpClient)))
        return vc
    }
    
}

class NewsSelectionFlow {
    
    let navigationController: UINavigationController
    let makeNewsViewController: (String) -> UIViewController
    
    internal init(navigationController: UINavigationController, makeNewsViewController: @escaping (String) -> UIViewController) {
        self.navigationController = navigationController
        self.makeNewsViewController = makeNewsViewController
    }
    
    func showNews(forSymbol symbol: String) {
        let vc = makeNewsViewController(symbol)
        navigationController.show(vc, sender: nil)
    }
}
