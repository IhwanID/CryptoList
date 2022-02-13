//
//  CryptoCell.swift
//  CryptoList
//
//  Created by Ihwan on 11/02/22.
//

import UIKit

class CryptoCell: UITableViewCell {
    @IBOutlet weak var coinSymbolLabel: UILabel!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tickerLabel: UILabel!
}

extension CryptoCell {
    func configure(_ vm: CryptoItemViewModel) {
        coinSymbolLabel.text = vm.symbol
        coinNameLabel.text = vm.name
        priceLabel.text = vm.price
        tickerLabel.text = vm.ticker
        tickerLabel.backgroundColor = vm.bgColor
    }
}
