//
//  CryptoListViewModel.swift
//  CryptoList
//
//  Created by Ihwan on 19/02/22.
//

import Foundation

class CryptoListViewModel {
    typealias Observer<T> = (T) -> Void
    
    var service: CryptoService?
    var onCoinsLoad: Observer<[Coin]>?
    var onCoinsError: Observer<Error>?
    
    
    init(service: CryptoService){
        self.service = service
    }
    
    func fetchCoins(){
        service?.load { [weak self] result in
            switch result {
            case let .success(coins):
                self?.onCoinsLoad?(coins)
            case let .failure(error):
                self?.onCoinsError?(error)
            }
        }
        
    }
}
