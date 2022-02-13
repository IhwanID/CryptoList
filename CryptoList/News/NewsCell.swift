//
//  NewsCell.swift
//  CryptoList
//
//  Created by Ihwan on 12/02/22.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
}

extension NewsCell {
    func configure(_ vm: NewsItemViewModel) {
        sourceLabel.text = vm.source
        titleLabel.text = vm.title
        bodyLabel.text = vm.body
    }
}
