//
//  Double+Extension.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 19.01.25.
//

import Foundation

extension Double {

    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 1
        formatter.currencySymbol = "$"
        return formatter
    }()

    private static let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        formatter.multiplier = 1
        return formatter
    }()

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

        guard let formattedNumber = Double.currencyFormatter.string(from: NSNumber(value: scaledValue))
        else { return nil }

        return "\(sign)\(formattedNumber)\(suffix)"
    }

    func formattedAsPercentageWithSymbol() -> String? {
        Double.percentageFormatter.string(from: NSNumber(value: self))
    }
}
