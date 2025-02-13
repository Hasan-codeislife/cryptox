//
//  APIManagerTests.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 20.01.25.
//

import Foundation
import Testing
@testable import cryptox

final class APIManagerTests {
    
    @Test func coinListNetworkCall() async throws {
        
        let mockData = loadJSONFile(with: "get_assets")!
        let mockResponse = HTTPURLResponse(
            url: URL(string: MockNetworkData.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        var mockAPIClient = MockAPIClient()
        mockAPIClient.mockResponse = (data: mockData, response: mockResponse)
        
        let apiManager = ApiManager(client: mockAPIClient)
        
        let router = CryptoEndpoint.getCoins(quantity: 10)
        let result: CoinParentNetworkModel = try await apiManager.makeNetworkCall(router: router)
        
        #expect(result.coins?.count == 2, "The json response should contain 2 coins")
    }
    
    @Test func coinDetailsNetworkCall() async throws {
        
        let mockData = loadJSONFile(with: "get_asset_details")!
        let mockResponse = HTTPURLResponse(
            url: URL(string: MockNetworkData.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        var mockAPIClient = MockAPIClient()
        mockAPIClient.mockResponse = (data: mockData, response: mockResponse)
        
        let apiManager = ApiManager(client: mockAPIClient)
        
        let id = try #require(MockDomainData.coins.first?.id)
        let router = CryptoEndpoint.getCoinDetails(id: id)
        let result: CoinDetailsParentNetworkModel = try await apiManager.makeNetworkCall(router: router)
        
        #expect(result.coin?.id == id, "The json response should return the expected coin")
    }

    private func loadJSONFile(with fileName: String) -> Data? {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json") else {
            print("File not found: \(fileName).json")
            return nil
        }
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            print("Error loading file: \(error)")
            return nil
        }
    }
    
}
