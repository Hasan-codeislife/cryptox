//
//  CoinListView.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import SwiftUI

struct CoinListView<ViewModel: CoinListViewModelProtocol>: View {
    @State var viewModel: ViewModel
    
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
                        .accessibilityIdentifier("coinList.loading")
                    Spacer()
                } else if viewModel.errorMessage != nil {
                    errorStateView
                } else if viewModel.coins.isEmpty {
                    emptyStateView
                } else {
                    listContent
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task { await viewModel.fetchCoins() }
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
        .accessibilityIdentifier("coinList.list")
    }

    private var emptyStateView: some View {
        VStack {
            CustomTextView(text: "No coins available.", fontType: .regular)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier("coinList.empty")
    }

    private var errorStateView: some View {
        VStack(spacing: 16) {
            CustomTextView(
                text: viewModel.errorMessage ?? "Something went wrong.",
                color: .customRed,
                fontType: .regular
            )
            Button("Retry") {
                Task { await viewModel.fetchCoins() }
            }
            .accessibilityIdentifier("coinList.retryButton")
            .foregroundColor(.customBlue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier("coinList.error")
    }
}
