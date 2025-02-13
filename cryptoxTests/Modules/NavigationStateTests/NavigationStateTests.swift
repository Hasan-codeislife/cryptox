//
//  NavigationStateTests.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 20.01.25.
//

import Foundation
import Testing
@testable import cryptox

class NavigationStateTests {
    var navigationState: NavigationState!
    
    init() {
        self.navigationState = NavigationState()
    }
    
    deinit {
        self.navigationState = nil
    }
    
    @Test func navigateToCoinList() {
        navigationState.navigate(to: .coinList)
        #expect(navigationState.path == [.coinList], "Expected to get navigation path Coin List")
    }

    @Test func navigateToCoinDetails() throws {
        navigationState.navigate(to: try getMockCoinDetailsRoute())
        let domainModel = try #require(MockDomainData.coins.first)
        #expect(navigationState.path == [.coinDetails(domainModel: domainModel,
                                                      initialModel: MockViewData.coinDetailsView)],
                "Expected to get pushed navigation of Coin Details")
    }
    
    @Test func navigateBack() throws {
        
        navigationState.navigate(to: .coinList)
        navigationState.navigate(to: try getMockCoinDetailsRoute())
        navigationState.navigateBack()
        #expect(navigationState.path == [.coinList],
                "Expected to pop back to Coin List")
    }
    
    @Test func navigateToRoot() throws {
        navigationState.navigate(to: try getMockCoinDetailsRoute())
        navigationState.navigateToRoot()
        #expect(navigationState.path.isEmpty, "Expected to pop back to Coin List")
    }
    
    private func getMockCoinDetailsRoute() throws -> AppRoute {
        let domainModel = try #require(MockDomainData.coins.first)
        let initialModel = MockViewData.coinDetailsView
        return .coinDetails(domainModel: domainModel,
                            initialModel: initialModel)
    }
}
