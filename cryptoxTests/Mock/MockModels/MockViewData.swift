//
//  MockData.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 20.01.25.
//

import Foundation
@testable import cryptox

enum MockViewData {
    static let coinDetailsView = CoinDetailsModel(
        id: "ethereum",
        name: "Ethereum",
        symbol: "ETH",
        imageURL: URL(string: "https://via.placeholder.com/150")!,
        priceUsd: "$3,000.00",
        changePercent24Hr: "+1.12%",
        marketCapUsd: "$400,000,000,000",
        volumeUsd24Hr: "$20,000,000,000",
        supply: "120,000,000",
        changeColor: .green
    )
}
