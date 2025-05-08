//
//  Untitled.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 06.05.25.
//

import ComposableArchitecture
import UIKit

@Reducer
class CoinListReducer: @unchecked Sendable {
    
    @ObservableState
    struct State: Equatable {
        var coins: [CoinViewModel] = []
        var domainCoins: [CoinModel] = []
        
        var selectedCoin: String?
        var isLoading: Bool = false
        var error: String? = nil
    }
    
    enum Action: Equatable {
        case loadCoins
        case setCoins([CoinViewModel], [CoinModel])
        case setLoading(Bool)
        case setError(String)
        case selectCoin(String)
    }
    
    @Dependency(\.service) private var service
    
    var body: some ReducerOf<CoinListReducer> {
        Reduce { state, action in
            switch action {
            case .loadCoins:
                state.isLoading = true
                state.error = nil
                return .run { send in
                    do {
                        let response = try await self.service.getCoins()
                        let mapper = CoinModelMapper()
                        let domainCoins = mapper.map(response)
                        let coins = self.transformToPresentationModels(from: domainCoins)
                        await send(.setCoins(coins, domainCoins))
                    } catch let error {
                        await send(.setError(error.localizedDescription))
                    }
                }
            case .setCoins(let coins, let domainCoins):
                state.coins = coins
                state.domainCoins = domainCoins
                state.isLoading = false
                return .none
                
            case .setLoading(let isLoading):
                state.isLoading = isLoading
                return .none
                
            case .setError(let error):
                state.error = error
                state.isLoading = false
                return .none
                
            case .selectCoin(let coinID):
                state.selectedCoin = coinID
                guard let domainModel = state.domainCoins.first(where: { $0.id == coinID }) else {
                    log("Warning: Failed to find domain model for ID: \(coinID)")
                    return .none
                }
                
//                guard let detailsModel = CoinDetailsViewModel.transformToPresentationModels(from: domainModel)
//                else {
//                    log("Warning: Failed to convert domain model to presentation model for ID: \(coinID)")
//                    return .none
//                }
                return .none
            }
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
    
//    func didTapRow(coinID: String) {
//        guard let (domainModel, detailsModel) = prepareModelsForDetails(coinID: coinID)
//        else { return }
////        navigationState.navigate(to: .coinDetails(domainModel: domainModel, initialModel: detailsModel))
//        
//    }
}
