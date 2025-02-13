//
//  APIManager.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import Foundation

enum NetworkError: Error, Equatable {
    
    case apiResponseError
    case unknown(String) // Captures a default-like case with a description
    
    /// Optional initializer to wrap any other Error into MyError
    init(_ error: Error) {
        if let myError = error as? NetworkError {
            self = myError
        } else {
            self = .unknown(error.localizedDescription)
        }
    }
}

protocol ApiManagerProtocol: Sendable {
    func makeNetworkCall<T: Decodable>(router: Routable) async throws -> T
}

struct ApiManager: ApiManagerProtocol {
    
    private let apiClient: APIClientProtocol
    
    init(client: APIClientProtocol) {
        self.apiClient = client
    }
    
    func makeNetworkCall<T: Decodable>(router: Routable) async throws -> T {
        let urlRequest = router.urlRequest
        let response = try await apiClient.dataTask(urlRequest)
        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode(T.self, from: response.data)
        return apiResponse
    }
}
