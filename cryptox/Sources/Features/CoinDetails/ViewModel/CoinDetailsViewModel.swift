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
    var coin: CoinDetailsModel { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    func fetchUpdatedCoinData() async
}

// MARK: - ViewModel Implementation
@MainActor
class CoinDetailsViewModel: CoinDetailsViewModelProtocol {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
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
    }
    
    // MARK: - Fetch Updated Data
    func fetchUpdatedCoinData() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let response = try await service.getCoinDetails(with: domainModel.id)
            guard let domainModel = mapper.map(response),
                  let coin = mapper.mapToDetails(domainModel)
            else { throw AppError.mapError }
            self.domainModel = domainModel
            self.coin = coin
        } catch {
            log("Error: \(error.localizedDescription)")
            errorMessage = NetworkError(error).userMessage
        }
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
