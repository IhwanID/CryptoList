//
//  StringExtension.swift
//  CryptoList
//
//  Created by Ihwan on 13/02/22.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
