//
//  MockCoinService.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 21.01.25.
//

import Foundation
@testable import cryptox

final class MockCoinService: CoinServiceProtocol, @unchecked Sendable {
    var mockListResponse: [CoinNetworkModel] = []
    var mockDetailsResponse: CoinNetworkModel?
    var shouldThrowError = false
    
    func getCoins() async throws -> [CoinNetworkModel] {
        if shouldThrowError {
            throw NetworkError.apiResponseError
        }
        return mockListResponse
    }
    
    func getCoinDetails(with id: String) async throws -> CoinNetworkModel {
        if shouldThrowError {
            throw NetworkError.apiResponseError
        }
        guard let response = mockDetailsResponse else {
            throw NetworkError.apiResponseError
        }
        return response
    }
}
