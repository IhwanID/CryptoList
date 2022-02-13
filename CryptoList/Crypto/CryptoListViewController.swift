//
//  CryptoListViewController.swift
//  CryptoList
//
//  Created by Ihwan on 11/02/22.
//

import UIKit

class CryptoListViewController: UITableViewController {
    
    var service: CryptoService?
    var webSocketConnection: WebSocketConnection?
    var select: (String) -> Void = { _ in }
    
    var coins: [Coin] = [] {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Toplists"
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        webSocketConnection?.delegate = self
        webSocketConnection?.connect()
 
    }
    
    @objc private func refresh(_ sender: Any) {
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    func fetchData(){
        refreshControl?.beginRefreshing()
        service?.load { [weak self] result in
            switch result {
            case let .success(coins):
                self?.coins = coins
                let subRequest = [
                    "action": "SubAdd",
                    "subs": coins.map{$0.subs}
                ] as [String : Any]
                
                if let requestString = subRequest.toJSONString() {
                    self?.webSocketConnection?.send(text: requestString)
                }
               
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
        cell.priceLabel.text = "\(coin.price.currencyFormat)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        select(coins[indexPath.row].symbol)
    }
    
}

extension CryptoListViewController : WebSocketConnectionDelegate {
    
    func onDisconnected(connection: WebSocketConnection, error: Error?) {
        print("==> onDisconnected")
    }
    
    func onError(connection: WebSocketConnection, error: Error) {
        print("==> onError")
    }
    
    func onMessage(connection: WebSocketConnection, text: String) {
        
        let data = Data(text.utf8)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        
        if let type = (json?["TYPE"] as? NSString)?.intValue {
            if type == 2 {
                let price: Double = json?["PRICE"] as? Double ?? 0
                let symbol: String = json?["FROMSYMBOL"] as! String
                
                if price > 0 {
                    if let row: Int = self.coins.firstIndex(where: {$0.symbol == symbol}) {
                        DispatchQueue.main.async {
                            let indexPath: IndexPath = NSIndexPath(row: row, section: 0) as IndexPath
                            let cell = self.tableView.cellForRow(at: indexPath) as! CryptoCell?
                            let currentPrice = self.coins[row].open24Hour
                           
                            let diffPrice: Double = price - currentPrice
                            let percentage = (diffPrice/price)
                            cell?.priceLabel.text = "\(price.currencyFormat)"
                            cell?.tickerLabel.backgroundColor = diffPrice.sign == .minus ? .red : .green
                            cell?.tickerLabel.text = "\(diffPrice.diffFomat)(\(percentage.percentageFormat))"
                        }
                        
                    }
                }
               
            }
        }
    }

}
