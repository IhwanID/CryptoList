//
//  CryptoListViewController.swift
//  CryptoList
//
//  Created by Ihwan on 11/02/22.
//

import UIKit

class CryptoListViewController: UITableViewController {
    let service: CryptoService = CryptoServiceAPI()
    private var webSocket: URLSessionWebSocketTask?
    
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
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let key = "7b9eee5bd406bb262532c51c3665375786b10d5b45c17bf0772d687b15842111"
        let url = URL(string: "wss://streamer.cryptocompare.com/v2?api_key=\(key)")!
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
        
        
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
        cell.priceLabel.text = "$ \(coin.price)"
        
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

extension CryptoListViewController: URLSessionWebSocketDelegate {
    func send() {
        DispatchQueue.global().asyncAfter(deadline: .now()+1) {
            let subRequest = [
                "action": "SubAdd",
                "subs": self.coins.map{$0.subs}
            ] as [String : Any]
            
            if let requestString = subRequest.toJSONString() {
                self.webSocket?.send(.string(requestString), completionHandler: { error in
                    if error != nil {
                        print("===> Error Send")
                    }
                })
            }
            
            
            
        }
    }
    
    func receive() {
        webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
                case .failure:
                    break
                case .success(let message):
                    switch message {
                    case .string(let text):
                        let data = Data(text.utf8)
                        let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                        
                        if let type = (json?["TYPE"] as? NSString)?.intValue {
                            if type == 2 {
                                let price: Double = json?["PRICE"] as? Double ?? 0
                                let symbol: String = json?["FROMSYMBOL"] as! String
                                
                                if let row: Int = self?.coins.firstIndex(where: {$0.symbol == symbol}) {
                                    DispatchQueue.main.async {
                                        let indexPath: IndexPath = NSIndexPath(row: row, section: 0) as IndexPath
                                        let cell = self?.tableView.cellForRow(at: indexPath) as! CryptoCell?
                                        let currentPrice = self?.coins[row].open24Hour ?? 0
                                       
                                        let diffPrice: Double = price - currentPrice
                                        let percentage = (diffPrice/price) * 100
                                        cell?.priceLabel.text = "$ \(price)"
                                        cell?.tickerLabel.backgroundColor = diffPrice.sign == .minus ? .red : .green
                                        cell?.tickerLabel.text = "\(diffPrice)(\(percentage)%)"
                                    }
                                    
                                }
                            }
                        }
                    case .data:
                        break
                    @unknown default:
                        break
                    }
                }
            
            
            self?.receive()
        })
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        send()
        receive()
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

