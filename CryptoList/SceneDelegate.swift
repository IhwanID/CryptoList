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
        let bundle = Bundle(for: CryptoListViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let vc = storyboard.instantiateInitialViewController() as! CryptoListViewController
        vc.title = title
        vc.service = CryptoServiceAPI(url: CryptoEndpoint.get(limit: 50).url(baseURL: baseURL), client: httpClient)
        return vc
    }


}

