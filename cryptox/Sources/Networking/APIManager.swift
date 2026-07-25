//
//  APIManager.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import Foundation

enum NetworkError: Error, Equatable {

    case invalidURL
    case apiResponseError
    case noConnection
    case clientError(Int)   // 4xx
    case serverError(Int)   // 5xx
    case decodingError
    case unknown(String)

    /// Wraps any Error into a typed NetworkError
    init(_ error: Error) {
        if let myError = error as? NetworkError {
            self = myError
        } else {
            self = .unknown(error.localizedDescription)
        }
    }

    var userMessage: String {
        switch self {
        case .noConnection:
            return "No internet connection. Please check your network and try again."
        case .clientError(let code):
            return "Request failed (\(code)). Please try again."
        case .serverError(let code):
            return "Server error (\(code)). Please try again later."
        case .decodingError:
            return "Unexpected response from the server."
        case .invalidURL, .apiResponseError, .unknown:
            return "Something went wrong. Please try again."
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
        guard let urlRequest = router.urlRequest else { throw NetworkError.invalidURL }
        let response = try await apiClient.dataTask(urlRequest)
        do {
            return try JSONDecoder().decode(T.self, from: response.data)
        } catch is DecodingError {
            throw NetworkError.decodingError
        }
    }
}
