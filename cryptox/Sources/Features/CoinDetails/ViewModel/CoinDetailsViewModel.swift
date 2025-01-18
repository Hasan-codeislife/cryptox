//
//  CoinDetailsViewModel.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 19.01.25.
//


import Foundation

// MARK: - ViewModel Protocol
@MainActor
protocol CoinDetailsViewModelProtocol: ObservableObject {
    var coin: CoinDetailsModel { get set }
    var domainModel: CoinModel { get set }
    var isLoading: Bool { get }
    var navigationState: NavigationStateProtocol { get set }
    var service: CoinServiceProtocol { get set }
    var mapper: CoinModelMapperProtocol { get set }
    
    func fetchUpdatedCoinData() async
}

// MARK: - ViewModel Implementation
@MainActor
class CoinDetailsViewModel: CoinDetailsViewModelProtocol {
    @Published var isLoading: Bool = false
    @Published var coin: CoinDetailsModel
    
    var domainModel: CoinModel
    var navigationState: NavigationStateProtocol
    var service: CoinServiceProtocol
    var mapper: CoinModelMapperProtocol
    
    // MARK: - Initialization
    init(
        navigationState: NavigationStateProtocol,
        service: CoinServiceProtocol,
        mapper: CoinModelMapperProtocol,
        domainModel: CoinModel,
        initialModel: CoinDetailsModel
    ) {
        self.navigationState = navigationState
        self.service = service
        self.mapper = mapper
        self.domainModel = domainModel
        
        // Initial values before the API call
        self.coin = initialModel
        
        Task {
            await fetchUpdatedCoinData()
        }
    }
    
    // MARK: - Fetch Updated Data
    func fetchUpdatedCoinData() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await service.getCoinDetails(with: domainModel.id)
            guard let domainModel = mapper.map(response),
                  let coin = CoinDetailsViewModel.transformToPresentationModels(from: domainModel)
            else { throw AppError.mapError }
            self.domainModel = domainModel
            self.coin = coin
        } catch {
            // Handle errors (e.g., show a popup, log)
            log("Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Transform Domain to Presentation Model
    static func transformToPresentationModels(from domain: CoinModel) -> CoinDetailsModel? {
        guard let formattedPrice = domain.priceUsd.formattedAsCurrencyWithAbbreviations(),
              let formattedPercentage = domain.changePercent24Hr.formattedAsPercentageWithSymbol(),
              let formattedMarketCap = domain.marketCapUsd.formattedAsCurrencyWithAbbreviations(),
              let formattedVolume = domain.volumeUsd24Hr.formattedAsCurrencyWithAbbreviations(),
              let formattedSupply = domain.supply.formattedAsCurrencyWithAbbreviations()
        else {
            log("Error: Failed to format domain model values.")
            return nil
        }
        
        return CoinDetailsModel(
            id: domain.id,
            name: domain.name.uppercased(),
            symbol: domain.symbol,
            imageURL: domain.imageURL,
            priceUsd: formattedPrice,
            changePercent24Hr: formattedPercentage,
            marketCapUsd: formattedMarketCap,
            volumeUsd24Hr: formattedVolume,
            supply: formattedSupply,
            changeColor: domain.changePercent24Hr >= 0 ? .customGreen : .customRed
        )
    }
    
    // MARK: - Navigation
    func navigateBack() {
        navigationState.navigateBack()
    }
}

// Using Factory to initialize the ViewModel
extension CoinDetailsViewModel {
    static func create(with navigation: NavigationStateProtocol,
                       domainModel: CoinModel,
                       initialModel: CoinDetailsModel) -> CoinDetailsViewModel {
        return CoinDetailsViewModel(
            navigationState: navigation,
            service: CoinService.create(),
            mapper: CoinModelMapper(),
            domainModel: domainModel, initialModel: initialModel
        )
    }
}
