//
//  MockURLSession.swift
//  cryptoxTests
//

import Foundation
@testable import cryptox

final class MockURLSession: URLSessionProtocol, @unchecked Sendable {
    var mockData: Data = Data()
    var mockStatusCode: Int = 200
    var mockError: Error?
    /// Set this to override with a non-HTTP URLResponse (e.g. to test the apiResponseError path)
    var mockURLResponse: URLResponse?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError { throw error }
        let response = mockURLResponse ?? HTTPURLResponse(
            url: request.url!,
            statusCode: mockStatusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        return (mockData, response)
    }
}
