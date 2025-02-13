//
//  CoinModelMapperTests.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 21.01.25.
//

import Foundation
import Testing
@testable import cryptox

final class CoinModelMapperTests {
    var mapper: CoinModelMapperProtocol = CoinModelMapper()
    
    @Test func networkModelToDomainMapping() throws {
        let mockNetworkModel = MockNetworkData.coins.first!
        let result = try #require(mapper.map(mockNetworkModel))
        #expect(mockNetworkModel == result, "Mapping of the network model to domain fails")
    }
    
    @Test func networkModelToDomainMappingWithMissingFields() throws {
        let mockNetworkModel = MockNetworkData.missingDataNetworkModel
        try #require(mapper.map(mockNetworkModel) == nil,  "Mapping should fail for missing fields")
    }

    @Test func multipleNetworkModelToDomainMapping() throws {
        let mockNetworkModels = MockNetworkData.coins
        let mapper = CoinModelMapper()

        let results = try #require(mapper.map(mockNetworkModels))

        #expect(results.count == mockNetworkModels.count, "Should map all valid models")
        
        // Verify each element in the mapping
        for (index, mockNetworkModel) in mockNetworkModels.enumerated() {
            guard index < results.count else {
                #expect(Bool(false), "Results array does not have expected number of elements.")
                return
            }
            #expect(mockNetworkModel == results[index], "Mapping of network model at index \(index) to domain model failed.")
        }
    }
}

extension CoinNetworkModel {
    static func == (lhs: CoinNetworkModel, rhs: CoinModel) -> Bool {
        guard let id = lhs.id,
              let name = lhs.name,
              let symbol = lhs.symbol,
              let priceUsdStr = lhs.priceUsd,
              let changePercent24HrStr = lhs.changePercent24Hr,
              let marketCapUsdStr = lhs.marketCapUsd,
              let volumeUsd24HrStr = lhs.volumeUsd24Hr,
              let supplyStr = lhs.supply,
              let priceUsd = Double(priceUsdStr),
              let changePercent24Hr = Double(changePercent24HrStr),
              let marketCapUsd = Double(marketCapUsdStr),
              let volumeUsd24Hr = Double(volumeUsd24HrStr),
              let supply = Double(supplyStr)
        else {
            return false
        }
        
        return id == rhs.id &&
        name == rhs.name &&
        symbol == rhs.symbol &&
        priceUsd == rhs.priceUsd &&
        changePercent24Hr == rhs.changePercent24Hr &&
        marketCapUsd == rhs.marketCapUsd &&
        volumeUsd24Hr == rhs.volumeUsd24Hr &&
        supply == rhs.supply
    }
}
