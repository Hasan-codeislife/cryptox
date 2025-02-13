//
//  String+Extension.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 20.01.25.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, bundle: .main, comment: "")
    }
}
