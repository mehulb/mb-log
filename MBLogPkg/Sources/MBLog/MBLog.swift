//
//  MBLog.swift
//  MBlog
//
//  Created by Mehul Bhavani on 20/01/23.
//

import Foundation
import OSLog

public class MBLog {
    private static let shared = MBLog()
    
    private static var config: Config?
    public class func setConfig(_ config: Config) {
        Self.config = config
    }
    
    private var fileOutputStream: FileHandlerOutputStream?
    
    private let dateFormatter = DateFormatter()
    
    private var didLogEnvironment = false
    
    private var logger: Logger
    
    private init() {
        guard Self.config != nil else {
            fatalError("Failed to setup logger - Call 'setup' before calling logger methods!")
        }

        self.logger = Logger(subsystem: Self.config!.moduleName, category: "MBLog")
        self.setup()
    }
    
    private func setup() {
        if Self.config!.shouldWriteToFile {
            setupFileOutputStream()
        } else {
            fileOutputStream = nil
        }
        logger = Logger(subsystem: Self.config!.moduleName, category: "MBLog")
    }
}

extension MBLog {
    private func setupFileOutputStream() {
        do {
            fileOutputStream = try FileHandlerOutputStream(withModuleName: Self.config!.moduleName)
            //print("Logging @\(String(describing: fileOutputStream?.fileUrl?.absoluteString))")
        } catch {
            print("Failed to create file stream @\(String(describing: fileOutputStream?.fileUrl?.absoluteString)) [ERR: \(error.localizedDescription)]")
        }
    }
}

extension MBLog {
    private func log(level: LogLevel, message: String, file: String = #file, function: String = #function, line: Int = #line) {
        guard level >= Self.config!.logLevel else { return }
        
        var fullString = ""
        
        if !didLogEnvironment {
            logToFile(Environment().description)
            didLogEnvironment = true
        }
        
        let start = Self.config!.delimiter.startChar
        let end = Self.config!.delimiter.endChar
        
        fullString = "\(start)\(level.prefix)\(end)"
        
        if Self.config!.showDatetime {
            fullString += "\(start)\(Date().string(formatter: dateFormatter, format: Self.config!.datetimeFormat))\(end)"
        }
        
        if Self.config!.shouldLogContext {
            let contextStr = Context(file: file, function: function, line: line).description.replacingOccurrences(of: "<#>", with: "\(end)\(start)")
            fullString += "\(start)\(contextStr)\(end)"
        }
        
        //fullString += " → ➤ ► "
        fullString += "\(Self.config!.messageSeparator)"
        fullString += message
        
        #if DEBUG
        logToDebugConsole(fullString)
        #else
        logToOSConsole(message, level: level)
        #endif
        
        logToFile(fullString)
    }
    
    private func logToDebugConsole(_ message: String) {
        print(message)
    }
    private func logToOSConsole(_ message: String, level: LogLevel) {
        switch level {
        case .debug: logger.debug("\(message)")
        case .info, .success: logger.info("\(message)")
        case .warning: logger.warning("\(message)")
        case .failure, .error: logger.error("\(message)")
        }
    }
    private func logToFile(_ message: String) {
        if Self.config!.shouldWriteToFile && fileOutputStream != nil {
            print(message, to: &fileOutputStream!)
        }
    }
    
    public static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Self.shared.log(level: .debug, message: message.description, file: file, function: function, line: line)
    }
    public static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Self.shared.log(level: .info, message: message.description, file: file, function: function, line: line)
    }
    public static func success(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Self.shared.log(level: .success, message: message.description, file: file, function: function, line: line)
    }
    public static func failure(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Self.shared.log(level: .failure, message: message.description, file: file, function: function, line: line)
    }
    public static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Self.shared.log(level: .warning, message: message.description, file: file, function: function, line: line)
    }
    public static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Self.shared.log(level: .error, message: message.description, file: file, function: function, line: line)
    }
    
    public static func logEnvironment() {
        let env = Environment().description
        Self.shared.logToDebugConsole(env)
        Self.shared.logToFile(env)
    }
    public static func logPath() -> String? {
        return Self.shared.fileOutputStream?.fileUrl?.path
    }
}

extension Date {
    func string(formatter: DateFormatter = DateFormatter(), format: String) -> String {
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

