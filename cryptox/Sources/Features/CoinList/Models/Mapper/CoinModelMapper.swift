//
//  CoinModelMapper.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 19.01.25.
//

//
//  CoinModelMapper.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 19.01.25.
//

import Foundation

protocol CoinModelMapperProtocol {
    func map(_ response: [CoinNetworkModel]) -> [CoinModel]
    func map(_ response: CoinNetworkModel) -> CoinModel?
}

struct CoinModelMapper: CoinModelMapperProtocol {
    func map(_ response: [CoinNetworkModel]) -> [CoinModel] {
        return response.compactMap { item in
            map(item)
        }
    }
    
    func map(_ response: CoinNetworkModel) -> CoinModel? {
        guard let id = response.id,
              let name = response.name,
              let symbol = response.symbol,
              let priceUsdStr = response.priceUsd,
              let changePercent24HrStr = response.changePercent24Hr,
              let marketCapUsdStr = response.marketCapUsd,
              let volumeUsd24HrStr = response.volumeUsd24Hr,
              let supplyStr = response.supply,
              let priceUsd = Double(priceUsdStr),
              let changePercent24Hr = Double(changePercent24HrStr),
              let marketCapUsd = Double(marketCapUsdStr),
              let volumeUsd24Hr = Double(volumeUsd24HrStr),
              let supply = Double(supplyStr)
        else {
            log("Warning: Failed to convert network model to domain model with ID: \(response.id ?? "unknown")")
            return nil
        }
        
        // Constructing the imageURL
        // Not a nice practice but I was not able to find assets
        let imageURLString = "https://assets.coincap.io/assets/icons/\(symbol.lowercased())@2x.png"
        guard let imageURL = URL(string: imageURLString) else {
            log("Warning: Invalid image URL for symbol: \(symbol)")
            return nil
        }
        
        return CoinModel(
            id: id,
            name: name,
            symbol: symbol,
            imageURL: imageURL,
            priceUsd: priceUsd,
            changePercent24Hr: changePercent24Hr,
            marketCapUsd: marketCapUsd,
            volumeUsd24Hr: volumeUsd24Hr,
            supply: supply
        )
    }
}
