//
//  CoinDetailsRowView.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 19.01.25.
//

import SwiftUI

struct CoinDetailsRowView: View {
    let label: String
    let value: String
    var labelColor: Color = .customBlack
    var valueColor: Color = .customBlack
    
    var body: some View {
        HStack {
            CustomTextView(text: label, color: labelColor, fontType: .regular)
            Spacer()
            CustomTextView(text: value, color: valueColor, fontType: .bold)
        }
    }
}
