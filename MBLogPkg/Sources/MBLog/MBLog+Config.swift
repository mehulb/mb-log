//
//  MBLog+Config.swift
//  MBLog
//
//  Created by Mehul Bhavani on 20/01/23.
//

import Foundation

extension MBLog {
    public struct Config {
        public enum Delimiter {
            case pipe
            case parentheses
            case brackets
            case braces
            case chevrons
            case period
            case hiphen
            case colon
            
            var startChar: String {
                switch self {
                case .pipe, .period, .hiphen, .colon: return ""
                case .parentheses: return "("
                case .brackets: return "["
                case .braces: return "{"
                case .chevrons: return "<"
                }
            }
            var endChar: String {
                switch self {
                case .pipe: return "|"
                case .parentheses: return ")"
                case .brackets: return "]"
                case .braces: return "}"
                case .chevrons: return ">"
                case .period: return "•"
                case .hiphen: return "-"
                case .colon: return ":"
                }
            }
        }
        
        public init() {}
        
        public var logLevel: LogLevel = .warning
        public var shouldLogContext = true
        public var shouldWriteToFile = true
        public var showDatetime = true
        public var datetimeFormat = "yy:MM:dd'T'HH:mm:ss"
        public var moduleName = "MBLogs"
        public var shouldLogEnvironment = true
        public var delimiter: Config.Delimiter = .pipe
        public var messageSeparator = "→"
    }
}
