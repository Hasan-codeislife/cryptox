//
//  MockNetworkData.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 21.01.25.
//

import Foundation
@testable import cryptox

enum MockNetworkData {
    static let baseURL: String = "https://api.coincap.io/v2/"
    
    static let coins: [CoinNetworkModel] = [
        CoinNetworkModel(
            id: "bitcoin",
            name: "Bitcoin",
            symbol: "BTC",
            priceUsd: "45000.00",
            changePercent24Hr: "-2.34",
            marketCapUsd: "850000000000.0",
            volumeUsd24Hr: "50000000000.0",
            supply: "19000000.0"
        ),
        CoinNetworkModel(
            id: "ethereum",
            name: "Ethereum",
            symbol: "ETH",
            priceUsd: "3000.00",
            changePercent24Hr: "1.12",
            marketCapUsd: "400000000000.0",
            volumeUsd24Hr: "20000000000.0",
            supply: "120000000.0"
        )
    ]
    
    static let missingDataNetworkModel: CoinNetworkModel = CoinNetworkModel(
        id: "bitcoin",
        name: nil,
        symbol: "BTC",
        priceUsd: "45000.00",
        changePercent24Hr: "2.34",
        marketCapUsd: "850000000000.0",
        volumeUsd24Hr: "50000000000.0",
        supply: "19000000.0"
    )

}
