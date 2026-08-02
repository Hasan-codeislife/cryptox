//
//  CoinListViewModel.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import Foundation

// MARK: - ViewModel Protocol
@MainActor
protocol CoinListViewModelProtocol: AnyObject {
    var coins: [CoinViewModel] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    func fetchCoins() async
    func didTapRow(coinID: String)
}

// MARK: - ViewModel Implementation
@MainActor
@Observable
class CoinListViewModel: CoinListViewModelProtocol {
    
    var coins: [CoinViewModel] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil

    var domainCoins: [CoinModel] = []
    var navigationState: NavigationStateProtocol
    var service: CoinServiceProtocol
    var mapper: CoinModelMapperProtocol
    private let userDefaults: UserDefaults

    // MARK: - Initialization
    init(
        navigationState: NavigationStateProtocol,
        service: CoinServiceProtocol,
        mapper: CoinModelMapperProtocol,
        userDefaults: UserDefaults = .standard
    ) {
        self.navigationState = navigationState
        self.service = service
        self.mapper = mapper
        self.userDefaults = userDefaults
        loadCachedCoins()
    }

    // MARK: - Methods
    func fetchCoins() async {
        // Only show the loading spinner on first launch (no cached data yet)
        isLoading = coins.isEmpty
        errorMessage = nil
        defer { isLoading = false }
        do {
            let response = try await service.getCoins()
            domainCoins = mapper.map(response)
            coins = transformToPresentationModels(from: domainCoins)
            cacheCoins(domainCoins)
        } catch {
            log("Error: \(error.localizedDescription)")
            // Only surface the error if there is nothing cached to show
            if coins.isEmpty {
                errorMessage = NetworkError(error).userMessage
            }
        }
    }
    
    private func transformToPresentationModels(from domainCoins: [CoinModel]) -> [CoinViewModel] {
        
        return domainCoins.compactMap { domainModel in
            guard let formattedPrice = domainModel.priceUsd.formattedAsCurrencyWithAbbreviations(),
                  let formattedPercentage = domainModel.changePercent24Hr.formattedAsPercentageWithSymbol() else {
                
                // Log a warning if transformation fails for a specific model
                // Better handled with better UI Alerts and state management
                log("Warning: Failed to format price or percentage for domain model with ID: \(domainModel.id)")
                return nil
            }
            
            return CoinViewModel(
                id: domainModel.id,
                name: domainModel.name.uppercased(),
                symbol: domainModel.symbol,
                imageURL: domainModel.imageURL,
                priceUsd: formattedPrice,
                changePercent24Hr: formattedPercentage,
                changeColor: domainModel.changePercent24Hr >= 0 ? .customGreen : .customRed
            )
        }
    }
    
    func didTapRow(coinID: String) {
        guard let (domainModel, detailsModel) = prepareModelsForDetails(coinID: coinID)
        else { return }
        navigationState.navigate(to: .coinDetails(domainModel: domainModel, initialModel: detailsModel))
        
    }
    
    func prepareModelsForDetails(coinID: String) -> (CoinModel, CoinDetailsModel)? {
        guard let domainModel = self.domainCoins.first(where: { $0.id == coinID }) else {
            log("Warning: Failed to find domain model for ID: \(coinID)")
            return nil
        }
        
        guard let detailsModel = mapper.mapToDetails(domainModel)
        else {
            log("Warning: Failed to convert domain model to presentation model for ID: \(coinID)")
            return nil
        }
        return (domainModel, detailsModel)
    }
}

// MARK: - Cache
extension CoinListViewModel {

    private enum CacheKey {
        static let coinList = "cache.coinList"
    }

    private func loadCachedCoins() {
        guard let data = userDefaults.data(forKey: CacheKey.coinList),
              let cached = try? JSONDecoder().decode([CoinModel].self, from: data)
        else { return }
        domainCoins = cached
        coins = transformToPresentationModels(from: cached)
    }

    private func cacheCoins(_ models: [CoinModel]) {
        guard let data = try? JSONEncoder().encode(models) else { return }
        userDefaults.set(data, forKey: CacheKey.coinList)
    }
}

// Using Factory to initialize the ViewModel
extension CoinListViewModel {
    static func create(with navigation: NavigationStateProtocol) -> CoinListViewModel {
        return CoinListViewModel(navigationState: navigation, service: CoinService.create(), mapper: CoinModelMapper())
    }
}
