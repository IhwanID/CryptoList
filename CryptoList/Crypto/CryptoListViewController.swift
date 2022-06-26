//
//  CryptoListViewController.swift
//  CryptoList
//
//  Created by Ihwan on 11/02/22.
//

import UIKit

class CryptoListViewController: UITableViewController {
    var viewModel: CryptoListViewModel?
    var select: (String) -> Void = { _ in }
    var webSocket: URLSessionWebSocketTask?
    
    private var coins: [Coin] = [] {
        didSet{
            guaranteeMainThread {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Toplists"
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        initWebSocket()
        connect()
        
        viewModel?.onCoinsLoad = { [weak self] coins in
            self?.coins = coins
            let subRequest = [
                "action": "SubAdd",
                "subs": coins.map{$0.subs}
            ] as [String : Any]
            
            if let requestString = subRequest.toJSONString() {
                self?.send(text: requestString)
            }
            
            guaranteeMainThread {
                self?.refreshControl?.endRefreshing()
            }
        }
        
        viewModel?.onCoinsError = { [weak self] error in
            guaranteeMainThread {
                self?.refreshControl?.endRefreshing()
                self?.handle(error) {
                    self?.viewModel?.fetchCoins()
                }
            }
        }
        
    }
    
    @objc private func refresh(_ sender: Any) {
        refreshControl?.beginRefreshing()
        viewModel?.fetchCoins()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshControl?.beginRefreshing()
        viewModel?.fetchCoins()
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
        let vm = CryptoItemViewModel(coin: coin, livePrice: coin.price)
        cell.configure(vm)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        select(coins[indexPath.row].symbol)
    }
    
}

extension CryptoListViewController: URLSessionWebSocketDelegate {
    func initWebSocket() {
        let webSocketURL = URL(string: "wss://streamer.cryptocompare.com/v2?api_key=7b9eee5bd406bb262532c51c3665375786b10d5b45c17bf0772d687b15842111")!
        webSocket = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue()).webSocketTask(with: webSocketURL)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("==> onConnected")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("==> onDisconnected")
    }
    
    func connect() {
        webSocket?.resume()
        
        listen()
    }
    
    func disconnect() {
        webSocket?.cancel(with: .goingAway, reason: nil)
    }
    
    func listen()  {
        webSocket?.receive { result in
            switch result {
            case .failure(let error):
                print("==> onFailure \(error.localizedDescription)")
            case .success(let message):
                switch message {
                case .string(let text):
                    let data = Data(text.utf8)
                    let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
                    if let type = (json?["TYPE"] as? NSString)?.intValue {
                        if type == 2 {
                            let price: Double = json?["PRICE"] as? Double ?? 0
                            let symbol: String = json?["FROMSYMBOL"] as! String
                            print("===> onMessage \(symbol) : \(price)")
                            if price > 0 {
                                if let row: Int = self.coins.firstIndex(where: {$0.symbol == symbol}) {
                                    DispatchQueue.main.async {
                                        let indexPath: IndexPath = NSIndexPath(row: row, section: 0) as IndexPath
                                        let cell = self.tableView.cellForRow(at: indexPath) as! CryptoCell?
                                        let vm = CryptoItemViewModel(coin: self.coins[row], livePrice: price)
                                        cell?.configure(vm)
                                    }
                                }
                            }
                        }
                    }
                    
                case .data(let data):
                    print("Data message: \(data)")
                @unknown default:
                    fatalError()
                }
                
                self.listen()
            }
        }
    }
    
    func send(text: String) {
        webSocket?.send(URLSessionWebSocketTask.Message.string(text)) { error in
            if let error = error {
                print("==> onError \(error.localizedDescription)")
            }
        }
    }
    
    func send(data: Data) {
        webSocket?.send(URLSessionWebSocketTask.Message.data(data)) { error in
            if let error = error {
                print("==> onError \(error.localizedDescription)")
            }
        }
    }
}
