//
//  DoubleExtension.swift
//  CryptoList
//
//  Created by Ihwan on 13/02/22.
//

import Foundation

extension Formatter {
    static let currencyFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 4
        formatter.numberStyle = .currency
        formatter.groupingSeparator = "."
        return formatter
    }()
    
    static let diffFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter
    }()
    
    static let percentageFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .percent
        formatter.groupingSeparator = "."
        return formatter
    }()
}

extension Double {
    var currencyFormat: String { Formatter.currencyFormat.string(for: self) ?? "" }
    var diffFomat: String { Formatter.diffFormat.string(for: self) ?? "" }
    var percentageFormat: String { Formatter.percentageFormat.string(for: self) ?? "" }
}
