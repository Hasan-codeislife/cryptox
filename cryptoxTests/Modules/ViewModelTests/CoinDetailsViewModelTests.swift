//
//  CoinDetailsViewModelTests.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 21.01.25.
//

import Foundation
import Testing
@testable import cryptox

@MainActor
final class CoinDetailsViewModelTests {
    
    var mockService: MockCoinService!
    var mockMapper: MockCoinModelMapper!
    var mockNavigationState: MockNavigationState!
    var viewModel: CoinDetailsViewModel!
    let domainModel = MockDomainData.coins.first!
    let initialModel = MockViewData.coinDetailsView
    
    init() {
        mockService = MockCoinService()
        mockMapper = MockCoinModelMapper()
        mockNavigationState = MockNavigationState()
        viewModel = CoinDetailsViewModel(navigationState: mockNavigationState,
                                         service: mockService,
                                         mapper: mockMapper, domainModel: domainModel, initialModel: initialModel)
    }
    
    @Test func initialModelSetup() {
        #expect(viewModel.coin.id == initialModel.id, "Coin should be initialized with the initial model")
        #expect(viewModel.domainModel.id == domainModel.id, "Domain model should match the provided domain model")
    }
    
    @Test func fetchUpdatedCoinData() async {
        
        await viewModel.fetchUpdatedCoinData()

        #expect(!viewModel.isLoading, "Loading state should be false after fetching data")
        #expect(viewModel.domainModel.id == domainModel.id, "Domain model should be updated correctly")
        #expect(viewModel.coin.id == initialModel.id, "Presentation model should be updated correctly")
    }

    @Test func transformToPresentationModel() throws {
        let result = try #require(CoinDetailsViewModel.transformToPresentationModels(from: domainModel))
        #expect(result == domainModel, "Mapping of network model at index \(index) to domain model failed.")
    }
}

extension CoinDetailsModel {
    static func == (lhs: CoinDetailsModel, rhs: CoinModel) -> Bool {
        guard let formattedPrice = rhs.priceUsd.formattedAsCurrencyWithAbbreviations(),
              let formattedChangePercent = rhs.changePercent24Hr.formattedAsPercentageWithSymbol(),
              let formattedMarketCap = rhs.marketCapUsd.formattedAsCurrencyWithAbbreviations(),
              let formattedVolume = rhs.volumeUsd24Hr.formattedAsCurrencyWithAbbreviations(),
              let formattedSupply = rhs.supply.formattedAsCurrencyWithAbbreviations()
        else {
            return false
        }
        
        return lhs.id == rhs.id &&
        lhs.name.lowercased() == rhs.name.lowercased() &&
        lhs.symbol.lowercased() == rhs.symbol.lowercased() &&
        lhs.imageURL == rhs.imageURL &&
        lhs.priceUsd == formattedPrice &&
        lhs.changePercent24Hr == formattedChangePercent &&
        lhs.marketCapUsd == formattedMarketCap &&
        lhs.volumeUsd24Hr == formattedVolume &&
        lhs.supply == formattedSupply &&
        lhs.changeColor == (rhs.changePercent24Hr >= 0 ? .customGreen : .customRed)
    }
}
