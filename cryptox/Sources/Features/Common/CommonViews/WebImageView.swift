//
//  WebImageView.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 20.01.25.
//

import SwiftUI

struct WebImageView: View {
    let url: URL
    var width: CGFloat = 56
    var height: CGFloat = 56
    
    var body: some View {
        AsyncImage(url: url) { image in
            image.resizable()
        } placeholder: {
            Image(ImageResource.coinPlaceholder)
        }
        .frame(width: width, height: height)
    }
}
