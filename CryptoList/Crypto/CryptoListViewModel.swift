//
//  CryptoListViewModel.swift
//  CryptoList
//
//  Created by Ihwan on 19/02/22.
//

import Foundation

class CryptoListViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let service: CryptoService
    private var onCoinsLoadObservers: [Observer<[Coin]>] = []
    var onCoinsError: Observer<Error>?
    var onCoinsLoading: Observer<Bool>?
    
    func add(coinsObserver: @escaping Observer<[Coin]>) {
        onCoinsLoadObservers.append(coinsObserver)
    }
    
    init(service: CryptoService){
        self.service = service
    }
    
    func fetchCoins(){
        onCoinsLoading?(true)
        service.load { [weak self] result in
            switch result {
            case let .success(coins):
                self?.onCoinsLoadObservers.forEach { $0(coins) }
            case let .failure(error):
                self?.onCoinsError?(error)
            }
            self?.onCoinsLoading?(false)
        }
        
    }
}
