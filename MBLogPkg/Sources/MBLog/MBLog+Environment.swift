//
//  MBLog+Environment.swift
//  MBLog
//
//  Created by Mehul Bhavani on 20/01/23.
//

import Foundation
#if os(iOS)
import UIKit
#endif

extension MBLog {
    struct Environment {
        private let deviceDetails: String
        private let osDetails: String
//        private let osName = ""
//        private let osVersion = ""
        
        init() {
            deviceDetails = "\(DeviceInfo.model) [\(DeviceInfo.machine)]"
            osDetails = "\(DeviceInfo.osType) [\(DeviceInfo.osVersion)]"
            #if os(iOS)
            #elseif os(macOS)
            #endif
        }
        
        var description: String {
            return """
---------------------------------------------------------
Device Hardware  : \(deviceDetails)
Operating System : \(osDetails)
---------------------------------------------------------
"""
        }
    }
}

private struct DeviceInfo {
    private enum Error: Swift.Error {
        case unknown
        case malformedUTF8
        case invalidSize
        case posixError(POSIXErrorCode)
    }
    
    private static func data(for keys: [Int32]) throws -> [Int8] {
        return try keys.withUnsafeBufferPointer() { keysPointer throws -> [Int8] in
            // Preflight the request to get the required data size
            var requiredSize = 0
            let preFlightResult = Darwin.sysctl(UnsafeMutablePointer<Int32>(mutating: keysPointer.baseAddress), UInt32(keys.count), nil, &requiredSize, nil, 0)
            if preFlightResult != 0 {
                throw POSIXErrorCode(rawValue: errno).map {
                    print($0.rawValue)
                    return Error.posixError($0)
                } ?? Error.unknown
            }
            
            // Run the actual request with an appropriately sized array buffer
            let data = Array<Int8>(repeating: 0, count: requiredSize)
            let result = data.withUnsafeBufferPointer() { dataBuffer -> Int32 in
                return Darwin.sysctl(UnsafeMutablePointer<Int32>(mutating: keysPointer.baseAddress), UInt32(keys.count), UnsafeMutableRawPointer(mutating: dataBuffer.baseAddress), &requiredSize, nil, 0)
            }
            if result != 0 {
                throw POSIXErrorCode(rawValue: errno).map { Error.posixError($0) } ?? Error.unknown
            }
            
            return data
        }
    }
    
    private static func string(for keys: [Int32]) throws -> String {
        let optionalString = try data(for: keys).withUnsafeBufferPointer() { dataPointer -> String? in
            dataPointer.baseAddress.flatMap { String(validatingUTF8: $0) }
        }
        guard let s = optionalString else {
            throw Error.malformedUTF8
        }
        return s
    }
    
    static var machine: String {
        #if os(iOS) && !arch(x86_64) && !arch(i386)
            return try! string(for: [CTL_HW, HW_MODEL])
        #else
            return try! string(for: [CTL_HW, HW_MACHINE])
        #endif
    }
    
    static var model: String {
        #if os(iOS) && !arch(x86_64) && !arch(i386)
            return try! string(for: [CTL_HW, HW_MACHINE])
        #else
            return try! string(for: [CTL_HW, HW_MODEL])
        #endif
    }
    
    static var osType: String {
        #if os(iOS)
        return "iOS"
        #elseif os(macOS)
        return "macOS"
        #endif
//        return "#NA"
    }
    
    static var osVersion: String {
        #if os(iOS)
        return UIDevice.current.systemVersion
        #elseif os(macOS)
        return ProcessInfo.processInfo.operatingSystemVersionString
        #endif
//        return "#NA"
    }
}
