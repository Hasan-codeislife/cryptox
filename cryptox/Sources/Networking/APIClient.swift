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
        let (data, urlResponse): (Data, URLResponse)
        do {
            (data, urlResponse) = try await URLSession.shared.data(for: request)
        } catch let urlError as URLError where urlError.code == .notConnectedToInternet
                                            || urlError.code == .networkConnectionLost {
            throw NetworkError.noConnection
        }
        guard let response = urlResponse as? HTTPURLResponse else {
            throw NetworkError.apiResponseError
        }
        guard (200...299).contains(response.statusCode) else {
            if (400...499).contains(response.statusCode) {
                throw NetworkError.clientError(response.statusCode)
            }
            throw NetworkError.serverError(response.statusCode)
        }
        return (data, response)
    }
}
