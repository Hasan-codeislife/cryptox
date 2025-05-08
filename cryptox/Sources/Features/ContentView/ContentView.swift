//
//  ContentView.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    private static let store = Store(initialState: CoinListReducer.State(), reducer: {
        CoinListReducer()
    })
    
    var body: some View {
        CoinListTCAView(store: Self.store)
    }

//    @ViewBuilder
//    private func viewForRoute(_ route: AppRoute) -> some View {
//        switch route {
//        case .coinList:
//            CoinListView(viewModel: CoinListViewModel.create(with: navigationState))
//        case .coinDetails(let domainModel, let initialModel):
//            CoinDetailsView(viewModel: CoinDetailsViewModel.create(with: navigationState, domainModel: domainModel, initialModel: initialModel))
//        }
//    }
}
