//
//  MBLog+Context.swift
//  MBLog
//
//  Created by Mehul Bhavani on 20/01/23.
//

import Foundation

extension MBLog {
    struct Context {
        let file: String
        let function: String
        let line: Int
        var description: String {
            return "\((file as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")).\(function)<#>L:\(line)"
        }
    }
}
