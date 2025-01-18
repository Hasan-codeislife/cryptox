//
//  DoubleFormattingTests.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 20.01.25.
//

import Foundation
import Testing
@testable import cryptox

final class DoubleFormattingTests {

    @Test func formattedAsCurrencyWithAbbreviations() {
        
        #expect(Double(1_500_000_000_000.0).formattedAsCurrencyWithAbbreviations() == "$1.5T")
        #expect(Double(-2_350_000_000_000.0).formattedAsCurrencyWithAbbreviations() == "-$2.4T")
        
        #expect(Double(1_500_000_000.0).formattedAsCurrencyWithAbbreviations() == "$1.5B")
        #expect(Double(-2_350_000_000.0).formattedAsCurrencyWithAbbreviations() == "-$2.4B")
        
        #expect(Double(1_250_000.0).formattedAsCurrencyWithAbbreviations() == "$1.2M")
        #expect(Double(-5_000_000.0).formattedAsCurrencyWithAbbreviations() == "-$5.0M")
        
        #expect(Double(5_500.0).formattedAsCurrencyWithAbbreviations() == "$5.5K")
        #expect(Double(-8_100.0).formattedAsCurrencyWithAbbreviations() == "-$8.1K")
        
        #expect(Double(999.0).formattedAsCurrencyWithAbbreviations() == "$999.0")
        #expect(Double(-999.0).formattedAsCurrencyWithAbbreviations() == "-$999.0")
        
        #expect(Double(0.0).formattedAsCurrencyWithAbbreviations() == "$0.0")
    }
    
    @Test func formattedAsPercentageWithSymbol() {
        
        #expect(Double(0.25).formattedAsPercentageWithSymbol() == "0.25%")
        #expect(Double(0.12345).formattedAsPercentageWithSymbol() == "0.12%")
        
        #expect(Double(-0.45678).formattedAsPercentageWithSymbol() == "-0.46%")
        #expect(Double(-0.05).formattedAsPercentageWithSymbol() == "-0.05%")
        
        #expect(Double(0.0).formattedAsPercentageWithSymbol() == "0.00%")
    }
}
