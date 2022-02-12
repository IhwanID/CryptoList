//
//  CryptoListViewController.swift
//  CryptoList
//
//  Created by Ihwan on 11/02/22.
//

import UIKit

class CryptoListViewController: UITableViewController {
    let service: CryptoService = CryptoServiceAPI()
    
    private var coins: [Coin] = [] {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    @objc private func refresh(_ sender: Any) {
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    func fetchData(){
        refreshControl?.beginRefreshing()
        service.loadCrypto(limit: 50) { [weak self] result in
            switch result {
            case let .success(coins):
                self?.coins = coins
            case let .failure(error):
                DispatchQueue.main.async {
                    self?.handle(error) {
                        self?.fetchData()
                    }
                }
            }
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return coins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cryptoCell") as! CryptoCell
        let coin = coins[indexPath.row]
        cell.coinNameLabel.text = coin.name
        cell.coinSymbolLabel.text = coin.symbol
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "newsVC") as! NewsViewController
        vc.title = "News"
        vc.categories = coins[indexPath.row].symbol
        let nav = UINavigationController(rootViewController: vc)
        showDetailViewController(nav, sender: nil)
    }
    
}

extension UIViewController {
    func handle(_ error: Error, completion: @escaping () -> ()) {
            let alert = UIAlertController(
                title: "An error occured",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(
                title: "Dismiss",
                style: .default
            ))

            alert.addAction(UIAlertAction(
                title: "Retry",
                style: .default,
                handler: { _ in
                    completion()
                }
            ))

            present(alert, animated: true)
        }
}
