//
//  MockCoinModelMapper.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 21.01.25.
//

import Foundation
@testable import cryptox

final class MockCoinModelMapper: CoinModelMapperProtocol {
    var listMockMappedCoins: [CoinModel] = []
    var detailsMockMappedCoin: CoinModel?
    var detailsPresentationModel: CoinDetailsModel? = MockViewData.coinDetailsView

    func map(_ response: [CoinNetworkModel]) -> [CoinModel] {
        return listMockMappedCoins
    }

    func map(_ response: CoinNetworkModel) -> CoinModel? {
        return detailsMockMappedCoin
    }

    func mapToDetails(_ domain: CoinModel) -> CoinDetailsModel? {
        return detailsPresentationModel
    }
}
