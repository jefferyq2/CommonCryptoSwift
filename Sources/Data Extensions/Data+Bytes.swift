//
//  Data+Bytes.swift
//  CommonCryptoSwift
//
//  Created by Chris Amanse on 15/08/2016.
//
//

import Foundation

extension Data {
    var unsafeBytes: UnsafePointer<UInt8> {
        return self.withUnsafeBytes { $0 }
    }
    
    var unsafeMutableBytes: UnsafeMutablePointer<UInt8> {
        mutating get {
            return self.withUnsafeMutableBytes { $0 }
        }
    }
}
