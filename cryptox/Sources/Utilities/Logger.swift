//
//  Logger.swift
//  cryptox
//
//  Created by Muhammad Hassan Asim on 21.01.25.
//

import Foundation

enum LogLevel: String {
  case debug, info, warning, error
}

func log(_ message: String, level: LogLevel = .debug) {
  #if DEBUG
  print("\(Date()) [\(level.rawValue.uppercased())] \(message)")
  #endif
}
