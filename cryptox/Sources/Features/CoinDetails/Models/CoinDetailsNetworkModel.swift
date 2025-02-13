//
//  CoinDetailsNetworkModel.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 19.01.25.
//

struct CoinDetailsParentNetworkModel: Decodable {
    var coin: CoinNetworkModel?
    enum CodingKeys: String, CodingKey {
        case coin = "data"
    }
}
