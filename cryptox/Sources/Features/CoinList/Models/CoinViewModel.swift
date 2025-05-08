//
//  CoinViewModel.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 19.01.25.
//

import SwiftUI

struct CoinViewModel: Equatable, Identifiable {
    
    let id: String
    let name: String
    let symbol: String
    let imageURL: URL
    let priceUsd: String
    let changePercent24Hr: String
    let changeColor: Color
}
