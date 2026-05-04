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
        GradientBackgroundView {
            VStack(alignment: .leading, spacing: 0) {
                CustomTextView(
                    text: "ui.coinsList.Title".localized.uppercased(),
                    fontSize: 32,
                    fontType: .bold
                )
                .padding(.horizontal)
                .padding(.top, 8)

                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if viewModel.coins.isEmpty {
                    emptyStateView
                } else {
                    listContent
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
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
