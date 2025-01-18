//
//  CoinListRowView.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 19.01.25.
//

import SwiftUI

struct CoinListRowView: View {
    let coin: CoinViewModel

    var body: some View {
        HStack(alignment: .top) {
            WebImageView(url: coin.imageURL)
            VStack(alignment: .leading) {
                CustomTextView(text: coin.name, fontSize: 20, fontType: .bold)
                CustomTextView(text: coin.symbol)
            }
            Spacer()
            VStack(alignment: .trailing) {
                CustomTextView(text: coin.priceUsd, fontType: .bold)
                CustomTextView(text: coin.changePercent24Hr, color: coin.changeColor, fontType: .bold)
                Spacer(minLength: 12)
                Image(systemName: SFSymbols.arrowRight.lowercased())
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(Color.customWhite.opacity(0.4))
        .cornerRadius(16)
    }
}
