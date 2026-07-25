//
//  CoinListViewModelTests.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 21.01.25.
//

import Foundation
import Testing
@testable import cryptox

@MainActor
final class CoinListViewModelTests {
    var mockService: MockCoinService!
    var mockMapper: MockCoinModelMapper!
    var mockNavigationState: MockNavigationState!
    var viewModel: CoinListViewModel!

    init() {
        mockService = MockCoinService()
        mockMapper = MockCoinModelMapper()
        mockNavigationState = MockNavigationState()
        viewModel = CoinListViewModel(
            navigationState: mockNavigationState,
            service: mockService,
            mapper: mockMapper
        )
    }
    
    @Test func initialFetchCoinsNetworkCalled() {
        #expect(viewModel.isLoading, "ViewModel should start in loading state")
    }
    
    @Test func fetchCoins() async {
        
        mockService.mockListResponse = MockNetworkData.coins
        mockMapper.listMockMappedCoins = MockDomainData.coins

        await viewModel.fetchCoins()

        #expect(!viewModel.isLoading, "Loading state should be false after fetching")
        #expect(viewModel.domainCoins == MockDomainData.coins, "Domain coins should be updated")
        #expect(viewModel.coins.count == MockDomainData.coins.count, "Presentation coins should match the domain coins count")
    }

    @Test func fetchCoinsTransformsPresentationModelsCorrectly() async {
        mockService.mockListResponse = MockNetworkData.coins
        mockMapper.listMockMappedCoins = MockDomainData.coins

        await viewModel.fetchCoins()

        let domainCoins = MockDomainData.coins
        #expect(viewModel.coins.count == domainCoins.count, "Should transform all domain coins to presentation models")

        for (index, domainCoin) in domainCoins.enumerated() {
            guard index < viewModel.coins.count else {
                #expect(Bool(false), "Results array does not have expected number of elements.")
                return
            }
            #expect(viewModel.coins[index] == domainCoin, "Mapping at index \(index) failed.")
        }
    }
    
    @Test func modelsForNavigationToDetails() {
        viewModel.domainCoins = MockDomainData.coins
        let models = viewModel.prepareModelsForDetails(coinID: MockDomainData.coins.first!.id)
        #expect(models != nil, "Should have ready models to navigate to detail")
    }
    
    @Test func modelsForNavigationToDetailsFailure() {
        viewModel.domainCoins = MockDomainData.coins
        let models = viewModel.prepareModelsForDetails(coinID: MockDomainData.randomIncorrectCoinId)
        #expect(models == nil, "Should not be able to navigate to details")
    }
}

extension CoinViewModel {
    static func == (lhs: CoinViewModel, rhs: CoinModel) -> Bool {
        guard let formattedPrice = rhs.priceUsd.formattedAsCurrencyWithAbbreviations(),
              let formattedChangePercent = rhs.changePercent24Hr.formattedAsPercentageWithSymbol()
        else {
            return false
        }
        
        return lhs.id == rhs.id &&
        lhs.name.lowercased() == rhs.name.lowercased() &&
        lhs.symbol.lowercased() == rhs.symbol.lowercased() &&
        lhs.imageURL == rhs.imageURL &&
        lhs.priceUsd == formattedPrice &&
        lhs.changePercent24Hr == formattedChangePercent &&
        lhs.changeColor == (rhs.changePercent24Hr >= 0 ? .customGreen : .customRed)
    }
}
