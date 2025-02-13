//
//  Font+Extension.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 19.01.25.
//

import Foundation
import SwiftUICore

extension Font {
    static func regular(size: CGFloat) -> Font {
        return .custom("Poppins-Regular", size: size)
    }
    
    static func bold(size: CGFloat) -> Font {
        return .custom("Poppins-Bold", size: size)
    }
}
