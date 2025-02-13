//
//  URLRequest.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import Foundation

extension URLRequest {
    init(requestURL: URL, method: APIMethod, header: [String: String]?, body: Any?) {
        self.init(url: requestURL)
        self.timeoutInterval = 30.0
        self.httpMethod = method.rawValue
        
        if let header {
            header.forEach { self.setValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        if let body {
            let httpBody: Data
            do {
                httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
                self.httpBody = httpBody
            } catch {
                return
            }
        }
    }
}
