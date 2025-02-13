//
//  CoinDetailsViewModel.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 19.01.25.
//

import SwiftUI

struct CoinDetailsModel: Hashable {
    
    let id: String
    let name: String
    let symbol: String
    let imageURL: URL
    let priceUsd: String
    let changePercent24Hr: String
    let marketCapUsd: String
    let volumeUsd24Hr: String
    let supply: String
    let changeColor: Color
}
