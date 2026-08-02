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
    var testUserDefaults: UserDefaults!

    private let suiteName = "test.coinList.\(UUID().uuidString)"

    init() {
        testUserDefaults = UserDefaults(suiteName: suiteName)
        mockService = MockCoinService()
        mockMapper = MockCoinModelMapper()
        mockNavigationState = MockNavigationState()
        viewModel = CoinListViewModel(
            navigationState: mockNavigationState,
            service: mockService,
            mapper: mockMapper,
            userDefaults: testUserDefaults
        )
    }

    deinit {
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
    }

    @Test func initialStateIsNotLoading() {
        #expect(!viewModel.isLoading, "ViewModel should not be loading before fetchCoins is called")
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

    // MARK: - Cache

    @Test func coinsAreCachedAfterSuccessfulFetch() async {
        mockService.mockListResponse = MockNetworkData.coins
        mockMapper.listMockMappedCoins = MockDomainData.coins
        await viewModel.fetchCoins()

        // Simulate relaunch: new ViewModel with same UserDefaults suite, no network response
        let relaunchedViewModel = CoinListViewModel(
            navigationState: mockNavigationState,
            service: MockCoinService(),
            mapper: mockMapper,
            userDefaults: testUserDefaults
        )

        #expect(relaunchedViewModel.coins.count == MockDomainData.coins.count,
                "Relaunched ViewModel should restore coins from cache without a network call")
    }

    @Test func noLoadingSpinnerWhenCacheExists() async {
        // Populate cache
        mockService.mockListResponse = MockNetworkData.coins
        mockMapper.listMockMappedCoins = MockDomainData.coins
        await viewModel.fetchCoins()

        // New ViewModel loads from cache — coins non-empty so isLoading stays false
        let cachedViewModel = CoinListViewModel(
            navigationState: mockNavigationState,
            service: mockService,
            mapper: mockMapper,
            userDefaults: testUserDefaults
        )

        #expect(!cachedViewModel.isLoading,
                "isLoading should be false when cached coins are pre-loaded")

        await cachedViewModel.fetchCoins()

        #expect(!cachedViewModel.isLoading,
                "isLoading should be false after background refresh completes")
    }

    @Test func errorNotShownWhenCacheExistsAndFetchFails() async {
        // Populate cache with a successful fetch
        mockService.mockListResponse = MockNetworkData.coins
        mockMapper.listMockMappedCoins = MockDomainData.coins
        await viewModel.fetchCoins()

        // Now fail the network
        mockService.shouldThrowError = true
        await viewModel.fetchCoins()

        #expect(viewModel.errorMessage == nil,
                "Error message should not be shown when cached coins are available")
        #expect(!viewModel.coins.isEmpty,
                "Cached coins should remain visible after a failed refresh")
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
