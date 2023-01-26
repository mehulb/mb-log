//
//  MBLog+LogLevel.swift
//  MBLog
//
//  Created by Mehul Bhavani on 20/01/23.
//

import Foundation

extension MBLog {
    public enum LogLevel: Int, Comparable {
        case debug
        case info
        case success
        case failure
        case warning
        case error
        
        var prefix: String {
            switch self {
            case .debug:    return "🐞"
            case .info:     return "ℹ️"
            case .success:  return "🟢"
            case .failure:  return "🔴"
            case .warning:  return "⚠️"
            case .error:    return "❌"
            }
        }
        
        public static func < (lhs: MBLog.LogLevel, rhs: MBLog.LogLevel) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
}
