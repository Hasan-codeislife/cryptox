//
//  MockDomainData.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 21.01.25.
//

import Foundation
@testable import cryptox

enum MockDomainData {
    
    static let randomIncorrectCoinId: String = "fakecoin"
    static let coins: [CoinModel] = [
        CoinModel(
            id: "bitcoin",
            name: "Bitcoin",
            symbol: "BTC",
            imageURL: URL(string: "https://via.placeholder.com/150")!,
            priceUsd: 45000.0,
            changePercent24Hr: -2.34,
            marketCapUsd: 850_000_000_000.0,
            volumeUsd24Hr: 50_000_000_000.0,
            supply: 19_000_000.0
        ),
        CoinModel(
            id: "ethereum",
            name: "Ethereum",
            symbol: "ETH",
            imageURL: URL(string: "https://via.placeholder.com/150")!,
            priceUsd: 3000.0,
            changePercent24Hr: 1.12,
            marketCapUsd: 400_000_000_000.0,
            volumeUsd24Hr: 20_000_000_000.0,
            supply: 120_000_000.0
        )
    ]
}
