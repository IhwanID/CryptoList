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

    private lazy var navigationController = UINavigationController(
        rootViewController: makeCryptoListViewController(title: "Toplists"))
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func makeCryptoListViewController(title: String) -> CryptoListViewController {
        let socketURL = URL(string: "wss://streamer.cryptocompare.com/v2?api_key=7b9eee5bd406bb262532c51c3665375786b10d5b45c17bf0772d687b15842111")!
        let bundle = Bundle(for: CryptoListViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let vc = storyboard.instantiateInitialViewController() as! CryptoListViewController
        vc.service = CryptoServiceAPI(url: CryptoEndpoint.get(limit: 50).url(baseURL: baseURL), client: httpClient)
        vc.webSocketConnection = WebSocketTaskConnection(url: socketURL)
        vc.select = { [self] symbol in
            let controller = self.makeNewsViewController(category: symbol)
            let nav = UINavigationController(rootViewController: controller)
            navigationController.showDetailViewController(nav, sender: nil)
        }
        return vc
    }
    
    func makeNewsViewController(category: String) -> NewsViewController {
        let bundle = Bundle(for: NewsViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "newsVC") as! NewsViewController
        vc.viewModel = NewsViewModel(service: NewsServiceAPI(url: NewsEndpoint.get(category: category).url(baseURL: baseURL), client: httpClient))
        return vc
    }

}

func guaranteeMainThread(_ work: @escaping () -> Void) {
    if Thread.isMainThread {
        work()
    } else {
        DispatchQueue.main.async(execute: work)
    }
}
