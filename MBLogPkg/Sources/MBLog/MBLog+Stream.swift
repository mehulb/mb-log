//
//  MBLog+Stream.swift
//  MBLog
//
//  Created by Mehul Bhavani on 20/01/23.
//

import Foundation

extension MBLog {
    struct FileHandlerOutputStream: TextOutputStream {
        enum FileHandlerOutputStreamError: Error {
            case failedToGenerateLogFileUrl
            case createFileFailed(path: String)
            case createDirectoryFailed(path: String)
        }
        
        private let fileHandle: FileHandle
        private let encoding: String.Encoding
        
        let fileUrl: URL?

        init(withModuleName moduleName: String) throws {
            fileUrl = Self.generateLogFileUrl(name: moduleName)
            guard let url = Self.generateLogFileUrl(name: moduleName) else {
                throw FileHandlerOutputStreamError.failedToGenerateLogFileUrl
            }
            let dirUrl = url.deletingLastPathComponent()
            if !FileManager.default.fileExists(atPath: dirUrl.path) {
                do {
                    try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true)
                } catch {
                    print("ERR:: Failed to create log directory\(dirUrl.path)")
                    throw FileHandlerOutputStreamError.createDirectoryFailed(path: dirUrl.path)
                }
            }
            if !FileManager.default.fileExists(atPath: url.path) {
                guard FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil) else {
                    throw FileHandlerOutputStreamError.createFileFailed(path: url.path)
                }
            }
            
            let fileHandle = try FileHandle(forWritingTo: url)
            fileHandle.seekToEndOfFile()
            self.fileHandle = fileHandle
            self.encoding = .utf8
        }

        mutating func write(_ string: String) {
            if let data = string.data(using: encoding) {
                fileHandle.write(data)
            }
        }
        
        private static func generateLogFileUrl(name: String) -> URL? {
            let formatter = DateFormatter()
            let logFileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("\(name)", isDirectory: true)
                .appendingPathComponent(Date().string(formatter: formatter, format: "yyyy-MM-dd"), isDirectory: true)
                .appendingPathComponent("\(Date().string(formatter: formatter, format: "yy-MM-dd-HHmmss")).log")
            return logFileUrl
        }
    }
}
