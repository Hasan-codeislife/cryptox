//
//  CoinModel.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import Foundation

struct CoinModel: Equatable, Hashable {
    
    let id: String
    let name: String
    let symbol: String
    let imageURL: URL
    let priceUsd: Double
    let changePercent24Hr: Double
    let marketCapUsd: Double
    let volumeUsd24Hr: Double
    let supply: Double

    init(id: String, name: String, symbol: String, imageURL: URL, priceUsd: Double, changePercent24Hr: Double, marketCapUsd: Double, volumeUsd24Hr: Double, supply: Double) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.imageURL = imageURL
        self.priceUsd = priceUsd
        self.changePercent24Hr = changePercent24Hr
        self.marketCapUsd = marketCapUsd
        self.volumeUsd24Hr = volumeUsd24Hr
        self.supply = supply
    }
}

