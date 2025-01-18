//
//  CoinNetworkModel.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import Foundation

struct CoinParentNetworkModel: Decodable {
    var coins: [CoinNetworkModel]?
    enum CodingKeys: String, CodingKey {
        case coins = "data"
    }
}

struct CoinNetworkModel: Equatable, Decodable {
    let id: String?
    let name: String?
    let symbol: String?
    let priceUsd: String?
    let changePercent24Hr: String?
    let marketCapUsd: String?
    let volumeUsd24Hr: String?
    let supply: String?
    
}
