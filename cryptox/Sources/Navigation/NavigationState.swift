//
//  NavigationState.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import SwiftUI

protocol NavigationStateProtocol {
    var path: [AppRoute] { get set }
    func navigate(to destination: AppRoute)
    func navigateBack()
    func navigateToRoot()
}

enum AppRoute: Hashable, Equatable {
    case coinList
    case coinDetails(domainModel: CoinModel, initialModel: CoinDetailsModel)
    
    var caseType: String {
        switch self {
        case .coinList:
            return "coinList"
        case .coinDetails:
            return "coinDetails"
        }
    }
}

final class NavigationState: NavigationStateProtocol, ObservableObject {
    @Published var path: [AppRoute] = []

    func navigate(to destination: AppRoute) {
        path.append(destination)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
}
