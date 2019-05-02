//
//  NumberFormat.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/29/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation

final class NumberFormat {
    
    
    
    private static let shared = NumberFormat()
    
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currency
        formatter.currencyCode = Constants.defaultCurrency
        return formatter
    }()
    
    private init() {
        // private
    }
    
    static func format(value: Int) -> String {
        let number = NSDecimalNumber(value: value)
        let numberDividedByOneHundred = number.dividing(by: NSDecimalNumber(value: 1))
        guard let formattedString = shared.formatter.string(from: numberDividedByOneHundred) else {
            fatalError("\(value) cannot be formatted correctly")
        }
        return formattedString
    }
    
}
