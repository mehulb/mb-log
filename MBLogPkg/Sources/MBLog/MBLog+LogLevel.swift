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
            case .debug:    return "đ"
            case .info:     return "âšī¸"
            case .success:  return "đĸ"
            case .failure:  return "đ´"
            case .warning:  return "â ī¸"
            case .error:    return "â"
            }
        }
        
        public static func < (lhs: MBLog.LogLevel, rhs: MBLog.LogLevel) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
}
