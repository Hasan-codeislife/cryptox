//
//  MockNavigationState.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 21.01.25.
//

import Foundation
@testable import cryptox

final class MockNavigationState: NavigationStateProtocol {
    var path: [AppRoute] = []
    
    func navigate(to destination: AppRoute) {
        path.append(destination)
    }

    func navigateBack() {
        path.removeLast()
    }

    func navigateToRoot() {
        path.removeAll()
    }
}
