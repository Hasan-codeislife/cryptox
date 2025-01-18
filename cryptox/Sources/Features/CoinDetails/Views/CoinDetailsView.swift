//
//  CoinDetailsView.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 18.01.25.
//

import SwiftUI

struct CoinDetailsView<ViewModel: CoinDetailsViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        GradientBackgroundView {
            VStack(spacing: 16) {
                cardView
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                CustomTextView(
                    text: viewModel.coin.name.uppercased(),
                    fontSize: 32,
                    fontType: .bold
                )
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                WebImageView(url: viewModel.coin.imageURL, width: 40, height: 40)
            }
        }
        
    }
    
    private var cardView: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                CoinDetailsRowView(label: "ui.coinDetails.priceTitle".localized,
                                   value: viewModel.coin.priceUsd)
                CoinDetailsRowView(label: "ui.coinDetails.changeTitle".localized,
                                   value: viewModel.coin.changePercent24Hr,
                                   valueColor: viewModel.coin.changeColor)
                
                Divider()
                    .frame(minHeight: 1)
                    .overlay(Color.customBlue)
                    .padding(.vertical, 8)
                
                CoinDetailsRowView(label: "ui.coinDetails.marketCapTitle".localized,
                                   value: viewModel.coin.marketCapUsd)
                CoinDetailsRowView(label: "ui.coinDetails.volumeTitle".localized,
                                   value: viewModel.coin.volumeUsd24Hr)
                CoinDetailsRowView(label: "ui.coinDetails.supplyTitle".localized,
                                   value: viewModel.coin.supply)
                
                Spacer()
            }
            .padding(24)
            .background(Color.customWhite.opacity(0.4))
            .cornerRadius(16)
            
            if viewModel.isLoading {
                Color.white.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .cornerRadius(16)
                    .overlay(
                        ProgressView()
                    )
            }
        }
        .padding(EdgeInsets(top: 24, leading: 24, bottom: 36, trailing: 24))
    }
}
