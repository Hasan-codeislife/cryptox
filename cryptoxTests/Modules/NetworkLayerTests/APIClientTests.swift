//
//  APIClientTests.swift
//  cryptoxTests
//

import Foundation
import Testing
@testable import cryptox

final class APIClientTests {

    private let request = URLRequest(url: URL(string: "https://example.com")!)

    // MARK: - Success

    @Test func successResponseReturnsData() async throws {
        let expectedData = Data("response".utf8)
        let session = MockURLSession()
        session.mockData = expectedData
        session.mockStatusCode = 200

        let result = try await APIClientURLSession(session: session).dataTask(request)

        #expect(result.data == expectedData)
        #expect(result.response.statusCode == 200)
    }

    // MARK: - HTTP Status Codes

    @Test func status404ThrowsClientError() async throws {
        let session = MockURLSession()
        session.mockStatusCode = 404

        await #expect(throws: NetworkError.clientError(404)) {
            try await APIClientURLSession(session: session).dataTask(request)
        }
    }

    @Test func status400ThrowsClientError() async throws {
        let session = MockURLSession()
        session.mockStatusCode = 400

        await #expect(throws: NetworkError.clientError(400)) {
            try await APIClientURLSession(session: session).dataTask(request)
        }
    }

    @Test func status500ThrowsServerError() async throws {
        let session = MockURLSession()
        session.mockStatusCode = 500

        await #expect(throws: NetworkError.serverError(500)) {
            try await APIClientURLSession(session: session).dataTask(request)
        }
    }

    @Test func status503ThrowsServerError() async throws {
        let session = MockURLSession()
        session.mockStatusCode = 503

        await #expect(throws: NetworkError.serverError(503)) {
            try await APIClientURLSession(session: session).dataTask(request)
        }
    }

    // MARK: - Network Errors

    @Test func notConnectedToInternetThrowsNoConnection() async throws {
        let session = MockURLSession()
        session.mockError = URLError(.notConnectedToInternet)

        await #expect(throws: NetworkError.noConnection) {
            try await APIClientURLSession(session: session).dataTask(request)
        }
    }

    @Test func networkConnectionLostThrowsNoConnection() async throws {
        let session = MockURLSession()
        session.mockError = URLError(.networkConnectionLost)

        await #expect(throws: NetworkError.noConnection) {
            try await APIClientURLSession(session: session).dataTask(request)
        }
    }

    // MARK: - Non-HTTP Response

    @Test func nonHTTPResponseThrowsAPIResponseError() async throws {
        let session = MockURLSession()
        // URLResponse (base class) is not castable to HTTPURLResponse
        session.mockURLResponse = URLResponse(
            url: request.url!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )

        await #expect(throws: NetworkError.apiResponseError) {
            try await APIClientURLSession(session: session).dataTask(request)
        }
    }
}
