//
//  CustomTextView.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 19.01.25.
//

import SwiftUI

struct CustomTextView: View {
    
    enum CustomTextViewFontType {
        case regular
        case bold
    }
    
    let text: String
    var color: Color = Color.customBlack
    var fontSize: CGFloat = 16
    var fontType: CustomTextViewFontType = .regular
    
    var body: some View {
        Text(text)
            .foregroundColor(color)
            .font(selectFont(size: fontSize, fontType: fontType))
        
    }
    
    private func selectFont(size: CGFloat, fontType: CustomTextViewFontType) -> Font {
        switch fontType {
        case .regular:
            return .regular(size: size)
        case .bold:
            return .bold(size: size)
        }
    }
}
