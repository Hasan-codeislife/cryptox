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
    
    @Test func fetchUpdatedCoinDataOnFailureKeepsInitialModel() async {
        // mockService.mockDetailsResponse is nil by default, so this exercises the failure path.
        await viewModel.fetchUpdatedCoinData()

        #expect(!viewModel.isLoading, "Loading state should be false after fetching data")
        #expect(viewModel.errorMessage != nil, "Error message should be set when the fetch fails")
        #expect(viewModel.domainModel.id == domainModel.id, "Domain model should be left untouched on failure")
        #expect(viewModel.coin.id == initialModel.id, "Presentation model should be left untouched on failure")
    }

    @Test func fetchUpdatedCoinDataOnSuccessUpdatesModel() async throws {
        let initialDomainModel = try #require(MockDomainData.coins.first) // bitcoin
        let updatedDomainModel = try #require(MockDomainData.coins.last)  // ethereum
        let updatedPresentationModel = MockViewData.coinDetailsView       // ethereum-based

        let freshViewModel = CoinDetailsViewModel(
            navigationState: mockNavigationState,
            service: mockService,
            mapper: mockMapper,
            domainModel: initialDomainModel,
            initialModel: try #require(CoinModelMapper().mapToDetails(initialDomainModel))
        )

        mockService.mockDetailsResponse = MockNetworkData.coins.last
        mockMapper.detailsMockMappedCoin = updatedDomainModel
        mockMapper.detailsPresentationModel = updatedPresentationModel

        await freshViewModel.fetchUpdatedCoinData()

        #expect(!freshViewModel.isLoading, "Loading state should be false after fetching data")
        #expect(freshViewModel.errorMessage == nil, "Error message should be nil after a successful fetch")
        #expect(freshViewModel.domainModel.id == updatedDomainModel.id, "Domain model should be replaced with the fetched coin")
        #expect(freshViewModel.coin.id == updatedPresentationModel.id, "Presentation model should be replaced with the fetched coin")
        #expect(freshViewModel.domainModel.id != initialDomainModel.id, "Sanity check: fetched coin should differ from the initial coin")
    }

    @Test func transformToPresentationModel() throws {
        let result = try #require(CoinModelMapper().mapToDetails(domainModel))
        #expect(result == domainModel, "Mapping domain model to presentation model failed.")
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
        lhs.isPositiveChange == (rhs.changePercent24Hr >= 0)
    }
}
