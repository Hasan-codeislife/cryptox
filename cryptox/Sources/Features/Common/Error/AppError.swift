//
//  AppError.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 19.01.25.
//

enum AppError: Error {
    
    case invalidData
    case mapError
    case unknown(String) // Captures a default-like case with a description
    
    /// Optional initializer to wrap any other Error into MyError
    init(_ error: Error) {
        if let myError = error as? AppError {
            self = myError
        } else {
            self = .unknown(error.localizedDescription)
        }
    }
}
