//
//  Double+Extension.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 19.01.25.
//

import Foundation

extension Double {
    func formattedAsCurrencyWithAbbreviations() -> String? {
        let absValue = abs(self)
        let sign = self < 0 ? "-" : ""
        let suffix: String
        let scaledValue: Double
        
        switch absValue {
        case 1_000_000_000_000...:
            scaledValue = absValue / 1_000_000_000_000
            suffix = "T"
        case 1_000_000_000...:
            scaledValue = absValue / 1_000_000_000
            suffix = "B"
        case 1_000_000...:
            scaledValue = absValue / 1_000_000
            suffix = "M"
        case 1_000...:
            scaledValue = absValue / 1_000
            suffix = "K"
        default:
            scaledValue = absValue
            suffix = ""
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 1
        formatter.currencySymbol = "$"
        
        guard let formattedNumber = formatter.string(from: NSNumber(value: scaledValue))
        else { return nil }
        
        return "\(sign)\(formattedNumber)\(suffix)"
    }
    
    func formattedAsPercentageWithSymbol() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        formatter.multiplier = 1
        
        return formatter.string(from: NSNumber(value: self))
    }
}
