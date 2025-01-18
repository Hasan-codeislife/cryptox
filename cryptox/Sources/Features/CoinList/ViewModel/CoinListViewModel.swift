//
//  CoinListViewModel.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import Foundation

// MARK: - ViewModel Protocol
@MainActor
protocol CoinListViewModelProtocol: ObservableObject {
    var coins: [CoinViewModel] { get }
    var domainCoins: [CoinModel] { get }
    var isLoading: Bool { get }
    var navigationState: NavigationStateProtocol { get set }
    var service: CoinServiceProtocol { get set }
    var mapper: CoinModelMapperProtocol { get set }
    
    func fetchCoins() async
    func didTapRow(coinID: String)
    func prepareModelsForDetails(coinID: String) -> (CoinModel, CoinDetailsModel)?
}

// MARK: - ViewModel Implementation
@MainActor
class CoinListViewModel: CoinListViewModelProtocol {
    
    @Published var coins: [CoinViewModel] = []
    @Published var isLoading: Bool = false
    
    var domainCoins: [CoinModel] = []
    var navigationState: NavigationStateProtocol
    var service: CoinServiceProtocol
    var mapper: CoinModelMapperProtocol
    
    // MARK: - Initialization
    init(
        navigationState: NavigationStateProtocol,
        service: CoinServiceProtocol,
        mapper: CoinModelMapperProtocol
    ) {
        self.navigationState = navigationState
        self.service = service
        self.mapper = mapper
        
        Task {
            await fetchCoins()
        }
    }
    
    // MARK: - Methods
    func fetchCoins() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await service.getCoins()
            domainCoins = mapper.map(response)
            coins = transformToPresentationModels(from: domainCoins)
        } catch {
            // Handle errors (e.g., show a popup, log)
            log("Error: \(error.localizedDescription)")
        }
    }
    
    func transformToPresentationModels(from domainCoins: [CoinModel]) -> [CoinViewModel] {
        
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
        
        guard let detailsModel = CoinDetailsViewModel.transformToPresentationModels(from: domainModel)
        else {
            log("Warning: Failed to convert domain model to presentation model for ID: \(coinID)")
            return nil
        }
        return (domainModel, detailsModel)
    }
}

// Using Factory to initialize the ViewModel
extension CoinListViewModel {
    static func create(with navigation: NavigationStateProtocol) -> CoinListViewModel {
        return CoinListViewModel(navigationState: navigation, service: CoinService.create(), mapper: CoinModelMapper())
    }
}
