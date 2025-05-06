//
//  CryptoEndpoint.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import Foundation

enum CryptoEndpoint: Routable {
        
    case getCoins(quantity: Int)
    case getCoinDetails(id: String)
    
    var path: String {
        switch self {
        case .getCoins(let quantity):
            return baseURLString + "assets?limit=\(quantity)&apiKey=\(apiKey)"
        case .getCoinDetails(let id):
            return baseURLString + "assets/\(id)&apiKey=\(apiKey)"
        }
    }
    
    var params: APIParams? {
        switch self {
        case .getCoins:
            return nil
        case .getCoinDetails:
            return nil
        }
    }
    
    var method: APIMethod {
        switch self {
        case .getCoins:
            return .get
        case .getCoinDetails:
            return .get
        }
    }
    
    var urlRequest: URLRequest {
        let url = URL(string: self.path)!
        return URLRequest(requestURL: url,
                          method: self.method,
                          header: nil,
                          body: self.params ?? nil)
    }
}
