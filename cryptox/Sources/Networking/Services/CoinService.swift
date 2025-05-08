//
//  CoinService.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import Foundation
import ComposableArchitecture

protocol CoinServiceProtocol: Sendable {
    func getCoins() async throws -> [CoinNetworkModel]
    func getCoinDetails(with id: String) async throws -> CoinNetworkModel
}

struct CoinService: CoinServiceProtocol {
    
    private let apiManager: ApiManagerProtocol
    init(apiManager: ApiManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func getCoins() async throws -> [CoinNetworkModel] {
        let endpoint = CryptoEndpoint.getCoins(quantity: 10)
        let response: CoinParentNetworkModel = try await apiManager.makeNetworkCall(router: endpoint)
        guard let assetsResponse = response.coins else {
            throw NetworkError.apiResponseError
        }
        return assetsResponse
    }
    
    func getCoinDetails(with id: String) async throws -> CoinNetworkModel {
        let endpoint = CryptoEndpoint.getCoinDetails(id: id)
        let response: CoinDetailsParentNetworkModel = try await apiManager.makeNetworkCall(router: endpoint)
        guard let assetResponse = response.coin else {
            throw NetworkError.apiResponseError
        }
        return assetResponse
    }
}

// Using Factory to initialize the Service
extension CoinService {
    static func create() -> CoinService {
        return CoinService(apiManager: ApiManager(client: APIClientURLSession()))
    }
}

extension CoinService: DependencyKey {
    static var liveValue: CoinService {
        return CoinService(apiManager: ApiManager(client: APIClientURLSession()))
    }
}

extension DependencyValues {
    var service: CoinService {
        get { self[CoinService.self] }
    }
}
