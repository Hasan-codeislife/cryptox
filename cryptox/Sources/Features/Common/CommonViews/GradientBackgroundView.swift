//
//  GradientBackgroundView.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 19.01.25.
//

import SwiftUI

struct GradientBackgroundView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
           LinearGradient(
            gradient: Gradient(colors: [Color.customGradientCyan, Color.customGradientPurple]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            content
        }
    }
}
