//
//  CoinListTCAView.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 06.05.25.
//

import SwiftUI
import ComposableArchitecture

struct CoinListTCAView: View {
    let store: StoreOf<CoinListReducer>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                GradientBackgroundView {
                    if store.isLoading {
                        ProgressView()
                    } else if store.coins.isEmpty {
                        emptyStateView
                    } else {
                        listContent
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            CustomTextView(
                                text: "ui.coinsList.Title".localized.uppercased(),
                                fontSize: 32,
                                fontType: .bold
                            )
                        }
                    }
                }
            }
            .onAppear {
                store.send(.loadCoins)
            }
            
        }
    }
    
    private var listContent: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewStore.coins, id: \.id) { coin in
                        CoinListRowView(coin: coin)
                            .onTapGesture {
                                // viewStore.didTapRow(coinID: coin.id)
                            }
                    }
                }
                .padding()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            CustomTextView(text: "No coins available.", fontType: .regular)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
