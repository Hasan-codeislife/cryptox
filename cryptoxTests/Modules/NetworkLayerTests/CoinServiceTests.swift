//
//  NetworkLayerTests.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 20.01.25.
//

import Foundation
import Testing
@testable import cryptox

final class CoinServiceTests {
    
    @Test func getCoinsList() async throws {
        
        let mockCoins = MockNetworkData.coins
        let mockResponse = CoinParentNetworkModel(coins: mockCoins)
        
        var mockApiManager = MockAPIManager()
        mockApiManager.mockResponse = mockResponse
        
        let service = CoinService(apiManager: mockApiManager)
        
        let coins = try await service.getCoins()
        
        #expect(coins == mockCoins, "The coins should match the mock response")
    }

    @Test func getCoinsListFailure() async throws {
        
        let mockResponse = CoinParentNetworkModel(coins: nil)
        
        var mockApiManager = MockAPIManager()
        mockApiManager.mockResponse = mockResponse
        
        let service = CoinService(apiManager: mockApiManager)

        do {
            _ = try await service.getCoins()
            #expect(Bool(false), "Expected NetworkError.apiResponseError but got success")
        } catch {
            #expect((error as? NetworkError) == NetworkError.apiResponseError,  "Expected NetworkError.apiResponseError but got error: \(error)")
        }
    }
    
    @Test func getCoinDetails() async throws {
        
        let mockCoin = MockNetworkData.coins.first!
        let mockResponse = CoinDetailsParentNetworkModel(coin: mockCoin)
        
        var mockApiManager = MockAPIManager()
        mockApiManager.mockResponse = mockResponse
        
        let service = CoinService(apiManager: mockApiManager)
        
        let id = try #require(MockDomainData.coins.first?.id)
        let coin = try await service.getCoinDetails(with: id)
        
        #expect(coin == mockCoin, "The coins should match the mock response")
    }

    @Test func getCoinDetailsFailure() async throws {
        
        let mockResponse = CoinDetailsParentNetworkModel(coin: nil)
        
        var mockApiManager = MockAPIManager()
        mockApiManager.mockResponse = mockResponse
        
        let service = CoinService(apiManager: mockApiManager)

        do {
            let id = try #require(MockDomainData.coins.first?.id)
            _ = try await service.getCoinDetails(with: id)
            #expect(Bool(false), "Expected NetworkError.apiResponseError but got success")
        } catch {
            #expect((error as? NetworkError) == NetworkError.apiResponseError,  "Expected NetworkError.apiResponseError but got error: \(error)")
        }
    }
}
