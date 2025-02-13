//
//  NetworkRoutable.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import Foundation

enum APIMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

typealias APIParams = [String: Any]?
typealias APIHeaders = [String: String]

protocol Routable {
    /// baseURL for calling any server
    var baseURLString: String { get }
    
    /// by default method is HTTPMethod.get
    var method: APIMethod { get }
    
    /// path should be appended with baseURL
    var path: String { get }
    var params: APIParams? { get }
    
    var urlRequest: URLRequest { get }
}

extension Routable {
    
    var baseURLString: String {
        return "https://api.coincap.io/v2/"
    }
}
