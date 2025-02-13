//
//  MockAPIManager.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 20.01.25.
//

import Foundation
@testable import cryptox

struct MockAPIManager: ApiManagerProtocol, @unchecked Sendable {
    var mockResponse: Any?
    var mockError: Error?

    func makeNetworkCall<T>(router: Routable) async throws -> T where T : Decodable {
        if let error = mockError {
            throw error
        }
        guard let response = mockResponse as? T else {
            throw NetworkError.apiResponseError
        }
        return response
    }
}
