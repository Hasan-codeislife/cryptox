//
//  CoinListView.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import SwiftUI

struct CoinListView<ViewModel: CoinListViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            GradientBackgroundView {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.coins.isEmpty {
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
    }
    
    private var listContent: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.coins, id: \.id) { coin in
                    CoinListRowView(coin: coin)
                        .onTapGesture {
                            viewModel.didTapRow(coinID: coin.id)
                        }
                }
            }
            .padding()
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            CustomTextView(text: "No coins available.", fontType: .regular)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
