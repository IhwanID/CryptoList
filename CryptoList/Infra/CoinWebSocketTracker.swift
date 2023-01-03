//
//  CoinWebSocketTracker.swift
//  CryptoList
//
//  Created by Ihwan on 03/01/23.
//

import Foundation

class CoinWebSocketTracker: NSObject, URLSessionWebSocketDelegate {
    var webSocket: URLSessionWebSocketTask?
    var didReceiveNewCoinPrice: (NewCoinPrice) -> Void = { _ in }
    
    init(url: URL, queue: OperationQueue) {
        super.init()
        webSocket = URLSession(configuration: .default, delegate: self, delegateQueue: queue).webSocketTask(with: url)
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
            case .failure:
                break
            case .success(let message):
                switch message {
                case .string(let text):
                    if let newPrice = try? NewCoinPriceMapper.map(Data(text.utf8)) {
                            self.didReceiveNewCoinPrice(newPrice)
                    }
                case .data:
                   break
                @unknown default:
                   break
                }
                
                self.listen()
            }
        }
    }
    
    func track(_ coins: [Coin]) {
        let subRequest = [
            "action": "SubAdd",
            "subs": coins.map{$0.subs}
        ] as [String : Any]
        
        if let requestString = subRequest.toJSONString() {
            self.send(text: requestString)
        }
    }
    
    func send(text: String) {
        webSocket?.send(URLSessionWebSocketTask.Message.string(text)) { _ in }
    }
    
}
