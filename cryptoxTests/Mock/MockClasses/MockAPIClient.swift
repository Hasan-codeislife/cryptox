//
//  MockAPIClient.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 20.01.25.
//

import Foundation
@testable import cryptox

struct MockAPIClient: APIClientProtocol {
    var mockResponse: MyURLResponse?
    var mockError: Error?

    func dataTask(_ request: URLRequest) async throws -> MyURLResponse {
        if let mockError {
            throw mockError
        }
        guard let mockResponse else {
            throw URLError(.unknown)
        }
        return mockResponse
    }
}
