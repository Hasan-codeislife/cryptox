//
//  APIClient.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import Foundation

typealias MyURLResponse = (data: Data, response: HTTPURLResponse)

protocol APIClientProtocol: Sendable {
    func dataTask(_ request: URLRequest) async throws -> MyURLResponse
}

struct APIClientURLSession: APIClientProtocol {
    func dataTask(_ request: URLRequest) async throws -> MyURLResponse {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.apiResponseError
        }
        return (data, response)
    }
}
