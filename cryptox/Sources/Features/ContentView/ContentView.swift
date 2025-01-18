//
//  ContentView.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var navigationState = NavigationState()
    
    var body: some View {
        NavigationStack(path: $navigationState.path) {
            CoinListView(viewModel: CoinListViewModel.create(with: navigationState))
                .navigationDestination(for: AppRoute.self) { route in
                    viewForRoute(route)
                }
        }
        .environmentObject(navigationState)
    }

    @ViewBuilder
    private func viewForRoute(_ route: AppRoute) -> some View {
        switch route {
        case .coinList:
            CoinListView(viewModel: CoinListViewModel.create(with: navigationState))
        case .coinDetails(let domainModel, let initialModel):
            CoinDetailsView(viewModel: CoinDetailsViewModel.create(with: navigationState, domainModel: domainModel, initialModel: initialModel))
        }
    }
}
